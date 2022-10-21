package tax;

import java.util.*;

public class SaleEBillBean {

	//Table : 세금계산서
	private String ResSeq;
	private String DocType;      
	private String DocCode;      
	private String Customs;      
	private String RefCoRegNo;   
	private String RefCoName;    
	private String RefMemId;    
	private String TaxSNum1;     
	private String TaxSNum2;     
	private String TaxSNum3;     
	private String DocAttr;      
	private String Origin;       
	private String PubDate;      
	private String SystemCode;   
	private String PubType;      
	private String PubForm;      
	private String BookNo1;      
	private String BookNo2;      
	private String Remarks;      
	private String MemID;        
	private String MemName;      
	private String Email;        
	private String Tel;          
	private String CoRegNo;      
	private String CoName;       
	private String CoCeo;        
	private String CoAddr;       
	private String CoBizType;    
	private String CoBizSub;     
	private String VidCheck;     
	private String RecMemID;     
	private String RecMemName;   
	private String RecEMail;     
	private String RecTel;       
	private String RecCoRegNo;   
	private String RecCoName;    
	private String RecCoCeo;     
	private String RecCoAddr;    
	private String RecCoBizType; 
	private String RecCoBizSub;  
	private int    SupPrice;     
	private int    Tax;          
	private int    Cash;         
	private int    Cheque;       
	private int    Bill;         
	private int    Outstand;     
	private String ItemDate1;    
	private String ItemName1;    
	private String ItemType1;    
	private int    ItemQyt1;     
	private int    ItemPrice1;   
	private int    ItemSupPrice1;
	private int    ItemTax1;     
	private String ItemRemarks1; 
	private String ItemDate2;    
	private String ItemName2;    
	private String ItemType2;    
	private int    ItemQyt2;     
	private int    ItemPrice2;   
	private int    ItemSupPrice2;
	private int    ItemTax2;     
	private String ItemRemarks2; 
	private String ItemDate3;    
	private String ItemName3;    
	private String ItemType3;    
	private int    ItemQyt3;     
	private int    ItemPrice3;   
	private int    ItemSupPrice3;
	private int    ItemTax3;     
	private String ItemRemarks3; 
	private String ItemDate4;    
	private String ItemName4;    
	private String ItemType4;    
	private int    ItemQyt4;     
	private int    ItemPrice4;   
	private int    ItemSupPrice4;
	private int    ItemTax4;     
	private String ItemRemarks4; 
	private String PubKind;      
	private int    LoadStatus;   
	private String PubCode;      
	private String PubStatus;    
	private String SeqID;    	
	private String Gubun;  //해지정산후 메일은 트러스빌에서    
	//2010 법인 의무발행 전자계산서 개편
	private int    EBillkind;			
	private String TaxSNum;				
	private String Remarks2;			
	private String Remarks3;			
	private String MemDeptName;			
	private String CoTaxRegNo;			
	private String RecMemDeptName;		
	private String RecMemId2;			
	private String RecMemDeptName2;		
	private String RecMemName2;			
	private String RecEMail2;			
	private String RecTel2;				
	private String RecCoRegNoType;		
	private String RecCoTaxRegNo;		
	private String BrokerMemId;			
	private String BrokerMemDeptName;	
	private String BrokerMemName;		
	private String BrokerEMail;			
	private String BrokerTel;			
	private String BrokerCoRegNo;		
	private String BrokerCoTaxRegNo;	
	private String BrokerCoName;		
	private String BrokerCeo;			
	private String BrokerAddr;			
	private String BrokerBizType;		
	private String BrokerBizSub;		
	private String Sms;					
	private String Nts_IssueId;			
	private String ItemSeqId;
	//20111031 입금표 
	private String DocKind;
	private String S_EbillKind;
	private String Client_id;


	// CONSTRCTOR            
	public SaleEBillBean() {  
		ResSeq				= "";
		DocType				= "";
		DocCode				= "";
		Customs				= "";
		RefCoRegNo			= "";
		RefCoName			= "";
		RefMemId			= "";
		TaxSNum1			= "";
		TaxSNum2			= "";
		TaxSNum3			= "";
		DocAttr				= "";
		Origin				= "";
		PubDate				= "";
		SystemCode			= "";
		PubType				= "";
		PubForm				= "";
		BookNo1				= "";
		BookNo2				= "";
		Remarks				= "";
		MemID				= "";
		MemName				= "";
		Email				= "";
		Tel					= "";
		CoRegNo				= "";
		CoName				= "";
		CoCeo				= "";
		CoAddr				= "";
		CoBizType			= "";
		CoBizSub			= "";
		VidCheck			= "";
		RecMemID			= "";
		RecMemName			= "";
		RecEMail			= "";
		RecTel				= "";
		RecCoRegNo			= "";
		RecCoName			= "";
		RecCoCeo			= "";
		RecCoAddr			= "";
		RecCoBizType		= "";
		RecCoBizSub			= "";
		SupPrice			= 0;
		Tax					= 0;
		Cash				= 0;
		Cheque				= 0;
		Bill				= 0;
		Outstand			= 0;
		ItemDate1			= "";
		ItemName1			= "";
		ItemType1			= "";
		ItemQyt1			= 0;
		ItemPrice1			= 0;
		ItemSupPrice1		= 0;
		ItemTax1			= 0;
		ItemRemarks1		= "";
		ItemDate2			= "";
		ItemName2			= "";
		ItemType2			= "";
		ItemQyt2			= 0;
		ItemPrice2			= 0;
		ItemSupPrice2		= 0;
		ItemTax2			= 0;
		ItemRemarks2		= "";
		ItemDate3			= "";
		ItemName3			= "";
		ItemType3			= "";
		ItemQyt3			= 0;
		ItemPrice3			= 0;
		ItemSupPrice3		= 0;
		ItemTax3			= 0;
		ItemRemarks3		= "";
		ItemDate4			= "";
		ItemName4			= "";
		ItemType4			= "";
		ItemQyt4			= 0;
		ItemPrice4			= 0;
		ItemSupPrice4		= 0;
		ItemTax4			= 0;
		ItemRemarks4		= "";
		PubKind				= "";
		LoadStatus			= 0;
		PubCode				= "";
		PubStatus			= "";
		SeqID				= "";
		Gubun				= "";
		EBillkind			= 0;          
		TaxSNum				= "";          
		Remarks2			= "";           
		Remarks3			= "";         
		MemDeptName			= "";       
		CoTaxRegNo			= "";         
		RecMemDeptName		= "";     
		RecMemId2			= "";       
		RecMemDeptName2		= "";     
		RecMemName2			= "";        
		RecEMail2			= "";        
		RecTel2				= "";        
		RecCoRegNoType		= "";   
		RecCoTaxRegNo		= "";     
		BrokerMemId			= "";      
		BrokerMemDeptName	= ""; 
		BrokerMemName		= "";      
		BrokerEMail			= "";       
		BrokerTel			= "";          
		BrokerCoRegNo		= "";     
		BrokerCoTaxRegNo	= "";    
		BrokerCoName		= "";      
		BrokerCeo			= "";         
		BrokerAddr			= "";      
		BrokerBizType		= "";    
		BrokerBizSub		= "";      
		Sms					= "";               
		Nts_IssueId			= "";     
		ItemSeqId			= "";
		DocKind				= "";
		S_EbillKind			= "";
		Client_id			= "";


	}

	//Set Method
	public void setResSeq				(String val){	if(val==null) val="";		ResSeq				= val;		}
	public void setDocType				(String val){	if(val==null) val="";		DocType				= val;		}
	public void setDocCode				(String val){	if(val==null) val="";		DocCode				= val;		}
	public void setCustoms				(String val){	if(val==null) val="";		Customs				= val;		}
	public void setRefCoRegNo			(String val){	if(val==null) val="";		RefCoRegNo			= val;		}	
	public void setRefCoName			(String val){	if(val==null) val="";		RefCoName			= val;		}	
	public void setRefMemId				(String val){	if(val==null) val="";		RefMemId			= val;		}	
	public void setTaxSNum1				(String val){	if(val==null) val="";		TaxSNum1			= val;		}
	public void setTaxSNum2				(String val){	if(val==null) val="";		TaxSNum2			= val;		}
	public void setTaxSNum3				(String val){	if(val==null) val="";		TaxSNum3			= val;		}
	public void setDocAttr				(String val){	if(val==null) val="";		DocAttr				= val;		}
	public void setOrigin				(String val){	if(val==null) val="";		Origin				= val;		}
	public void setPubDate				(String val){	if(val==null) val="";		PubDate				= val;		}
	public void setSystemCode			(String val){	if(val==null) val="";		SystemCode			= val;		}
	public void setPubType				(String val){	if(val==null) val="";		PubType				= val;		}
	public void setPubForm				(String val){	if(val==null) val="";		PubForm				= val;		}
	public void setBookNo1				(String val){	if(val==null) val="";		BookNo1				= val;		}
	public void setBookNo2				(String val){	if(val==null) val="";		BookNo2				= val;		}
	public void setRemarks				(String val){	if(val==null) val="";		Remarks				= val;		}
	public void setMemID				(String val){	if(val==null) val="";		MemID				= val;		}
	public void setMemName				(String val){	if(val==null) val="";		MemName				= val;		}
	public void setEmail				(String val){	if(val==null) val="";		Email				= val;		}
	public void setTel					(String val){	if(val==null) val="";		Tel					= val;		}
	public void setCoRegNo				(String val){	if(val==null) val="";		CoRegNo				= val;		}
	public void setCoName				(String val){	if(val==null) val="";		CoName				= val;		}
	public void setCoCeo				(String val){	if(val==null) val="";		CoCeo				= val;		}
	public void setCoAddr				(String val){	if(val==null) val="";		CoAddr				= val;		}
	public void setCoBizType			(String val){	if(val==null) val="";		CoBizType			= val;		}
	public void setCoBizSub				(String val){	if(val==null) val="";		CoBizSub			= val;		}
	public void setVidCheck				(String val){	if(val==null) val="";		VidCheck			= val;		}
	public void setRecMemID				(String val){	if(val==null) val="";		RecMemID			= val;		}
	public void setRecMemName			(String val){	if(val==null) val="";		RecMemName			= val;		}
	public void setRecEMail				(String val){	if(val==null) val="";		RecEMail			= val;		}	
	public void setRecTel				(String val){	if(val==null) val="";		RecTel				= val;		}	
	public void setRecCoRegNo			(String val){	if(val==null) val="";		RecCoRegNo			= val;		}
	public void setRecCoName			(String val){	if(val==null) val="";		RecCoName			= val;		}
	public void setRecCoCeo				(String val){	if(val==null) val="";		RecCoCeo			= val;		}
	public void setRecCoAddr			(String val){	if(val==null) val="";		RecCoAddr			= val;		}
	public void setRecCoBizType			(String val){	if(val==null) val="";		RecCoBizType		= val;		}
	public void setRecCoBizSub			(String val){	if(val==null) val="";		RecCoBizSub			= val;		}
	public void setSupPrice				(int    val){								SupPrice			= val;		}
	public void setTax					(int    val){								Tax					= val;		}
	public void setCash					(int    val){								Cash				= val;		}
	public void setCheque				(int    val){								Cheque				= val;		}
	public void setBill					(int    val){								Bill				= val;		}
	public void setOutstand				(int    val){								Outstand			= val;		}
	public void setItemDate1			(String val){	if(val==null) val="";		ItemDate1			= val;		}
	public void setItemName1			(String val){	if(val==null) val="";		ItemName1			= val;		}
	public void setItemType1			(String val){	if(val==null) val="";		ItemType1			= val;		}
	public void setItemQyt1				(int    val){								ItemQyt1			= val;		}
	public void setItemPrice1			(int    val){								ItemPrice1			= val;		}
	public void setItemSupPrice1		(int    val){								ItemSupPrice1		= val;		}
	public void setItemTax1				(int    val){								ItemTax1			= val;		}
	public void setItemRemarks1			(String val){	if(val==null) val="";		ItemRemarks1		= val;		}
	public void setItemDate2			(String val){	if(val==null) val="";		ItemDate2			= val;		}
	public void setItemName2			(String val){	if(val==null) val="";		ItemName2			= val;		}
	public void setItemType2			(String val){	if(val==null) val="";		ItemType2			= val;		}
	public void setItemQyt2				(int    val){								ItemQyt2			= val;		}
	public void setItemPrice2			(int    val){								ItemPrice2			= val;		}
	public void setItemSupPrice2		(int    val){								ItemSupPrice2		= val;		}	
	public void setItemTax2				(int    val){								ItemTax2			= val;		}	
	public void setItemRemarks2			(String val){	if(val==null) val="";		ItemRemarks2		= val;		}
	public void setItemDate3			(String val){	if(val==null) val="";		ItemDate3			= val;		}
	public void setItemName3			(String val){	if(val==null) val="";		ItemName3			= val;		}
	public void setItemType3			(String val){	if(val==null) val="";		ItemType3			= val;		}
	public void setItemQyt3				(int    val){								ItemQyt3			= val;		}
	public void setItemPrice3			(int    val){								ItemPrice3			= val;		}
	public void setItemSupPrice3		(int    val){								ItemSupPrice3		= val;		}
	public void setItemTax3				(int    val){								ItemTax3			= val;		}
	public void setItemRemarks3			(String val){	if(val==null) val="";		ItemRemarks3		= val;		}
	public void setItemDate4			(String val){	if(val==null) val="";		ItemDate4			= val;		}
	public void setItemName4			(String val){	if(val==null) val="";		ItemName4			= val;		}
	public void setItemType4			(String val){	if(val==null) val="";		ItemType4			= val;		}
	public void setItemQyt4				(int    val){								ItemQyt4			= val;		}
	public void setItemPrice4			(int    val){								ItemPrice4			= val;		}
	public void setItemSupPrice4		(int    val){								ItemSupPrice4		= val;		}
	public void setItemTax4				(int    val){								ItemTax4			= val;		}
	public void setItemRemarks4			(String val){	if(val==null) val="";		ItemRemarks4		= val;		}
	public void setPubKind				(String val){	if(val==null) val="";		PubKind				= val;		}
	public void setLoadStatus			(int    val){								LoadStatus			= val;		}
	public void setPubCode				(String val){	if(val==null) val="";		PubCode				= val;		}
	public void setPubStatus			(String val){	if(val==null) val="";		PubStatus			= val;		}
	public void setSeqID				(String val){	if(val==null) val="";		SeqID				= val;		}
	public void setGubun				(String val){	if(val==null) val="";		Gubun				= val;		}
	public void setEBillkind			(int    val){								EBillkind			= val;		}
	public void setTaxSNum				(String val){	if(val==null) val="";		TaxSNum				= val;		}
	public void setRemarks2				(String val){	if(val==null) val="";		Remarks2			= val;		}
	public void setRemarks3				(String val){	if(val==null) val="";		Remarks3			= val;		}
	public void setMemDeptName			(String val){	if(val==null) val="";		MemDeptName			= val;		}
	public void setCoTaxRegNo			(String val){	if(val==null) val="";		CoTaxRegNo			= val;		}
	public void setRecMemDeptName		(String val){	if(val==null) val="";		RecMemDeptName		= val;		}
	public void setRecMemId2			(String val){	if(val==null) val="";		RecMemId2			= val;		}
	public void setRecMemDeptName2		(String val){	if(val==null) val="";		RecMemDeptName2		= val;		}
	public void setRecMemName2			(String val){	if(val==null) val="";		RecMemName2			= val;		}
	public void setRecEMail2			(String val){	if(val==null) val="";		RecEMail2			= val;		}
	public void setRecTel2				(String val){	if(val==null) val="";		RecTel2				= val;		}
	public void setRecCoRegNoType		(String val){	if(val==null) val="";		RecCoRegNoType		= val;		}
	public void setRecCoTaxRegNo		(String val){	if(val==null) val="";		RecCoTaxRegNo		= val;		}
	public void setBrokerMemId			(String val){	if(val==null) val="";		BrokerMemId			= val;		}
	public void setBrokerMemDeptName	(String val){	if(val==null) val="";		BrokerMemDeptName	= val;		}
	public void setBrokerMemName		(String val){	if(val==null) val="";		BrokerMemName		= val;		}
	public void setBrokerEMail			(String val){	if(val==null) val="";		BrokerEMail			= val;		}
	public void setBrokerTel			(String val){	if(val==null) val="";		BrokerTel			= val;		}
	public void setBrokerCoRegNo		(String val){	if(val==null) val="";		BrokerCoRegNo		= val;		}
	public void setBrokerCoTaxRegNo		(String val){	if(val==null) val="";		BrokerCoTaxRegNo	= val;		}
	public void setBrokerCoName			(String val){	if(val==null) val="";		BrokerCoName		= val;		}
	public void setBrokerCeo			(String val){	if(val==null) val="";		BrokerCeo			= val;		}
	public void setBrokerAddr			(String val){	if(val==null) val="";		BrokerAddr			= val;		}
	public void setBrokerBizType		(String val){	if(val==null) val="";		BrokerBizType		= val;		}
	public void setBrokerBizSub			(String val){	if(val==null) val="";		BrokerBizSub		= val;		}
	public void setSms					(String val){	if(val==null) val="";		Sms					= val;		}
	public void setNts_IssueId			(String val){	if(val==null) val="";		Nts_IssueId			= val;		}
	public void setItemSeqId			(String val){	if(val==null) val="";		ItemSeqId			= val;		}
	public void setDocKind				(String val){	if(val==null) val="";		DocKind				= val;		}
	public void setS_EbillKind			(String val){	if(val==null) val="";		S_EbillKind			= val;		}
	public void setClient_id			(String val){	if(val==null) val="";		Client_id			= val;		}



	//Get Method
	public String getResSeq					(){		return		ResSeq;				}
	public String getDocType				(){		return		DocType;			}
	public String getDocCode				(){		return		DocCode;			}
	public String getCustoms				(){		return		Customs;			}
	public String getRefCoRegNo				(){		return		RefCoRegNo;			}	
	public String getRefCoName				(){		return		RefCoName;			}	
	public String getRefMemId				(){		return		RefMemId;			}	
	public String getTaxSNum1				(){		return		TaxSNum1;			}
	public String getTaxSNum2				(){		return		TaxSNum2;			}
	public String getTaxSNum3				(){		return		TaxSNum3;			}
	public String getDocAttr				(){		return		DocAttr;			}
	public String getOrigin					(){		return		Origin;				}
	public String getPubDate				(){		return		PubDate;			}
	public String getSystemCode				(){		return		SystemCode;			}
	public String getPubType				(){		return		PubType;			}
	public String getPubForm				(){		return		PubForm;			}
	public String getBookNo1				(){		return		BookNo1;			}
	public String getBookNo2				(){		return		BookNo2;			}
	public String getRemarks				(){		return		Remarks;			}
	public String getMemID					(){		return		MemID;				}
	public String getMemName				(){		return		MemName;			}
	public String getEmail					(){		return		Email;				}
	public String getTel					(){		return		Tel;				}
	public String getCoRegNo				(){		return		CoRegNo;			}
	public String getCoName					(){		return		CoName;				}
	public String getCoCeo					(){		return		CoCeo;				}
	public String getCoAddr					(){		return		CoAddr;				}
	public String getCoBizType				(){		return		CoBizType;			}	
	public String getCoBizSub				(){		return		CoBizSub;			}
	public String getVidCheck				(){		return		VidCheck;			}
	public String getRecMemID				(){		return		RecMemID;			}
	public String getRecMemName				(){		return		RecMemName;			}
	public String getRecEMail				(){		return		RecEMail;			}	
	public String getRecTel					(){		return		RecTel;				}	
	public String getRecCoRegNo				(){		return		RecCoRegNo;			}
	public String getRecCoName				(){		return		RecCoName;			}
	public String getRecCoCeo				(){		return		RecCoCeo;			}
	public String getRecCoAddr				(){		return		RecCoAddr;			}
	public String getRecCoBizType			(){		return		RecCoBizType;		}
	public String getRecCoBizSub			(){		return		RecCoBizSub;		}
	public int    getSupPrice				(){		return		SupPrice;			}
	public int    getTax					(){		return		Tax;				}
	public int    getCash					(){		return		Cash;				}
	public int    getCheque					(){		return		Cheque;				}
	public int    getBill					(){		return		Bill;				}
	public int    getOutstand				(){		return		Outstand;			}
	public String getItemDate1				(){		return		ItemDate1;			}
	public String getItemName1				(){		return		ItemName1;			}
	public String getItemType1				(){		return		ItemType1;			}
	public int    getItemQyt1				(){		return		ItemQyt1;			}
	public int    getItemPrice1				(){		return		ItemPrice1;			}
	public int    getItemSupPrice1			(){		return		ItemSupPrice1;		}
	public int    getItemTax1				(){		return		ItemTax1;			}
	public String getItemRemarks1			(){		return		ItemRemarks1;		}
	public String getItemDate2				(){		return		ItemDate2;			}	
	public String getItemName2				(){		return		ItemName2;			}
	public String getItemType2				(){		return		ItemType2;			}
	public int    getItemQyt2				(){		return		ItemQyt2;			}
	public int    getItemPrice2				(){		return		ItemPrice2;			}
	public int    getItemSupPrice2			(){		return		ItemSupPrice2;		}	
	public int    getItemTax2				(){		return		ItemTax2;			}	
	public String getItemRemarks2			(){		return		ItemRemarks2;		}
	public String getItemDate3				(){		return		ItemDate3;			}
	public String getItemName3				(){		return		ItemName3;			}
	public String getItemType3				(){		return		ItemType3;			}
	public int    getItemQyt3				(){		return		ItemQyt3;			}
	public int    getItemPrice3				(){		return		ItemPrice3;			}
	public int    getItemSupPrice3			(){		return		ItemSupPrice3;		}
	public int    getItemTax3				(){		return		ItemTax3;			}
	public String getItemRemarks3			(){		return		ItemRemarks3;		}
	public String getItemDate4				(){		return		ItemDate4;			}
	public String getItemName4				(){		return		ItemName4;			}
	public String getItemType4				(){		return		ItemType4;			}
	public int    getItemQyt4				(){		return		ItemQyt4;			}
	public int    getItemPrice4				(){		return		ItemPrice4;			}
	public int    getItemSupPrice4			(){		return		ItemSupPrice4;		}
	public int    getItemTax4				(){		return		ItemTax4;			}
	public String getItemRemarks4			(){		return		ItemRemarks4;		}
	public String getPubKind				(){		return		PubKind;			}
	public int    getLoadStatus				(){		return		LoadStatus;			}
	public String getPubCode				(){		return		PubCode;			}
	public String getPubStatus				(){		return		PubStatus;			}
	public String getSeqID					(){		return		SeqID;				}	
	public String getGubun					(){		return		Gubun;				}	
	public int    getEBillkind				(){		return		EBillkind;			}
	public String getTaxSNum				(){		return		TaxSNum;			}
	public String getRemarks2				(){		return		Remarks2;			}
	public String getRemarks3				(){		return		Remarks3;			}	
	public String getMemDeptName			(){		return		MemDeptName;		}	
	public String getCoTaxRegNo				(){		return		CoTaxRegNo;			}
	public String getRecMemDeptName			(){		return		RecMemDeptName;		}
	public String getRecMemId2				(){		return		RecMemId2;			}	
	public String getRecMemDeptName2		(){		return		RecMemDeptName2;	}	
	public String getRecMemName2			(){		return		RecMemName2;		}
	public String getRecEMail2				(){		return		RecEMail2;			}
	public String getRecTel2				(){		return		RecTel2;			}	
	public String getRecCoRegNoType			(){		return		RecCoRegNoType;		}	
	public String getRecCoTaxRegNo			(){		return		RecCoTaxRegNo;		}
	public String getBrokerMemId			(){		return		BrokerMemId;		}
	public String getBrokerMemDeptName		(){		return		BrokerMemDeptName;	}	
	public String getBrokerMemName			(){		return		BrokerMemName;		}	
	public String getBrokerEMail			(){		return		BrokerEMail;		}
	public String getBrokerTel				(){		return		BrokerTel;			}
	public String getBrokerCoRegNo			(){		return		BrokerCoRegNo;		}	
	public String getBrokerCoTaxRegNo		(){		return		BrokerCoTaxRegNo;	}	
	public String getBrokerCoName			(){		return		BrokerCoName;		}
	public String getBrokerCeo				(){		return		BrokerCeo;			}
	public String getBrokerAddr				(){		return		BrokerAddr;			}	
	public String getBrokerBizType			(){		return		BrokerBizType;		}	
	public String getBrokerBizSub			(){		return		BrokerBizSub;		}
	public String getSms					(){		return		Sms;				}
	public String getNts_IssueId			(){		return		Nts_IssueId;		}	
	public String getItemSeqId				(){		return		ItemSeqId;			}	
	public String getDocKind				(){		return		DocKind;			}	
	public String getS_EbillKind			(){		return		S_EbillKind;		}	
	public String getClient_id				(){		return		Client_id;		}

}
