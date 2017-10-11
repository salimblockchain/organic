/*
 * This is a smart contract to develop functionality
 * of POC for blockchain.
 */

package main

/* Imports
 * Utility libraries for formatting, reading and writing JSON, and string manipulation
 * Specific Hyperledger Fabric specific libraries for Smart Contracts
 */
import (
	//"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	//"strings"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

// Define the Smart Contract structure
type BlockChainPOC struct {
}

// LOT structure, now it contains 13 properties. But, we will have to add other properties as well.
type LOTDetail struct {
	LOTNum 		string `json:"lotnum"`
	WrkFlow_stg  	string `json:"wrkflow_stg"`
	Supplier_Name 	string `json:"supplier_name"`
	Supplier_Site  	string `json:"supplier_site"`
	Shipment_Date	string `json:"shipment_date"`
	Product_ID		string `json:"product_id"`
	Product_Qty		string `json:"product_qty"`
	Product_Price	string `json:"product_price"`
	Logistic_ID		string `json:"logistic_id"`
	Logistic_Name	string `json:"logistic_name"`
	Dlv_Dt_To_Mnfctr	string `json:"dlv_dt_to_mnfctr"`
	Career_Name		string `json:"career_name"`
	ManPlantId		string `json:"manplantid"`

}

/*
 * The Init method is called when the Smart Contract "blockchainpoc" is instantiated by the blockchain network
 * We have put Ledger initialization in separate function for testing -- see initLedger()
 */
func (s *BlockChainPOC) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

/*
 * The Invoke method is called as a result of an application request to run the Smart Contract "blockchainpoc"
 */
func (s *BlockChainPOC) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "searchTransactionsForLOT" {
		return s.searchTransactionsForLOT(APIstub, args)
	} else if function == "initLedger" {
		return s.initLedger(APIstub)
	} else if function == "addTransactionForItems" {
		return s.addTransactionForItems(APIstub, args)
	} 
	
	return shim.Error("Invalid Smart Contract function name.")
}

/*
This will search the transaction details against LOT number
*/
func (s *BlockChainPOC) searchTransactionsForLOT(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	lotAsBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(lotAsBytes)
}

// Now this function takes all item related value as argument but in future item related values will be passed 
// as jSON
func (s *BlockChainPOC) addTransactionForItems(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	
		// This check will be changed when other fields will be added.
		if len(args) != 14 {
			return shim.Error("Incorrect number of arguments. Expecting 2")
		}
		var key string
		key = args[0]
		var lotDetail = LOTDetail{LOTNum: args[1], WrkFlow_stg: args[2], Supplier_Name: args[3], Supplier_Site: args[4], Shipment_Date: args[5], Product_ID: args[6], Product_Qty: args[7], Product_Price: args[8], Logistic_ID: args[9], Logistic_Name: args[10], Dlv_Dt_To_Mnfctr: args[11], Career_Name: args[12], ManPlantId: args[13]}
		
		outputMapBytes, err := json.Marshal(lotDetail)
		APIstub.PutState(key, outputMapBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success([]byte("SUCCESS"))
}

func (s *BlockChainPOC) initLedger(APIstub shim.ChaincodeStubInterface) sc.Response {
		
	lots := []LOTDetail{
		LOTDetail{LOTNum: "1", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl12", Supplier_Site: "Suppl1_Site", Shipment_Date: "02-Jan-17", Product_ID: "Prod1", Product_Qty: "50", Product_Price: "100", Logistic_ID: "Log1", Logistic_Name: "Logistic1", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "2", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl1", Supplier_Site: "Suppl1_Site", Shipment_Date: "02-Jan-17", Product_ID: "Prod2", Product_Qty: "100", Product_Price: "200", Logistic_ID: "Log1", Logistic_Name: "Logistic1", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "3", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl1", Supplier_Site: "Suppl1_Site", Shipment_Date: "02-Jan-17", Product_ID: "Prod3", Product_Qty: "150", Product_Price: "300", Logistic_ID: "Log1", Logistic_Name: "Logistic1", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "4", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl1", Supplier_Site: "Suppl1_Site", Shipment_Date: "02-Jan-17", Product_ID: "Prod4", Product_Qty: "200", Product_Price: "400", Logistic_ID: "Log1", Logistic_Name: "Logistic1", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "5", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl2", Supplier_Site: "Suppl2_Site", Shipment_Date: "03-Jan-17", Product_ID: "Prod5", Product_Qty: "50", Product_Price: "100", Logistic_ID: "Log2", Logistic_Name: "Logistic2", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "6", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl2", Supplier_Site: "Suppl2_Site", Shipment_Date: "03-Jan-17", Product_ID: "Prod6", Product_Qty: "100", Product_Price: "200", Logistic_ID: "Log2", Logistic_Name: "Logistic2", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "7", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl2", Supplier_Site: "Suppl2_Site", Shipment_Date: "03-Jan-17", Product_ID: "Prod7", Product_Qty: "150", Product_Price: "300", Logistic_ID: "Log2", Logistic_Name: "Logistic3", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
		LOTDetail{LOTNum: "8", WrkFlow_stg: "SHIP_READY", Supplier_Name: "Suppl2", Supplier_Site: "Suppl2_Site", Shipment_Date: "03-Jan-17", Product_ID: "Prod8", Product_Qty: "200", Product_Price: "400", Logistic_ID: "Log2", Logistic_Name: "Logistic3", Dlv_Dt_To_Mnfctr: "", Career_Name: "", ManPlantId: ""},
	}

	i := 0
	for i < len(lots) {
		fmt.Println("i is ", i)
		lotAsBytes, _ := json.Marshal(lots[i])
		APIstub.PutState("LOTNum" + strconv.Itoa(i), lotAsBytes)
		fmt.Println("Added", lots[i])
		i = i + 1
	}

	return shim.Success(nil)
}

//check whether string has value or not
func getStringValue(input interface{}) string {
	var value string
	var isOk bool

	if input == nil {
		value = ""
	} else {
		value, isOk = input.(string)
		if isOk == false {
			value = ""
		}
	}
	return value
}


// The main function is only relevant in unit test mode. Only included here for completeness.
func main() {

	// Create a new Smart Contract
	err := shim.Start(new(BlockChainPOC))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
