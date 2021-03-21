/**
 * Created by Aleksei on 17.03.2021.
 */
@IsTest
private class ProductTriggerTest {

    @IsTest static void changeFlagTest(){
        System.assertEquals(productTriggerHelper.flag, true);
        productTriggerHelper.changeFlag();
        System.assertEquals(productTriggerHelper.flag, false);
        productTriggerHelper.changeFlag();
        System.assertEquals(productTriggerHelper.flag, true);
    }

    @IsTest static void getFlagTest(){
        System.assertEquals(productTriggerHelper.flag, productTriggerHelper.getFlagValue());
    }

    @IsTest static void onceFiredTriggerTest(){
        System.assert(productTriggerHelper.flag);

        Test.startTest();
        Database.UpsertResult result = Database.upsert(new Product2(Name='TestProduct'));
        Test.stopTest();

        System.assert(productTriggerHelper.flag == false);
    }
}