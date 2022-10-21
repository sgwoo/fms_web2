package acar.util;

public interface Webconst {

	interface path1_info {
		/**
		 * 대메뉴 정보
		 */

		/** [0] : 대메뉴 코드, [1] : 중메뉴코드 : [2] 노출 여부 : [3]카테고리명 **/
		public final String[][] MENU_DEPTH_1 = { 
				{ "01", "01", "true","" }, { "02", "01", "true" }
				, { "03", "01", "true","" }, { "04", "01", "true","" }
				, { "05", "01", "true","" }, { "06", "01", "true","" }
				, { "07", "01", "true","" }, { "08", "04", "true","" }
				, { "09", "02", "true","" }, { "10", "01", "true","" }
				, { "17", "04", "true","" }, { "11", "01", "true","" }
				, { "16", "01", "true","" }, { "18", "01", "false","" }
				, { "12", "01", "false","" }, { "13", "01", "false","" }
				, { "14", "01", "false","" }, { "15", "01", "false","" }
				, { "99", "01", "false","" } 
		};
		
		/**
		 * 에이전트 대메뉴 정보
		 */
		public final String[][] MENU_DEPTH_1_AGENT = {
				{"22", "09","true","Agent"}
		};
		
		/**
		 * 협력사 대메뉴 정보
		 */
		public final String[][] MENU_DEPTH_1_PARTNER = {
				{"26", "01","true", "배달탁송"}
				,{"33", "01","true","탁송관리"}
				,{"29", "05","true","자동차관리"}
		};
		
		public final String MENU_DEPTH_1_SEPARATOR = "01,02,03,04,05,06,07,08,09,10,17,11,16,18,12,13,14,15,99";
		public final String MENU_AGENT_SEPARATOR = "22";
		public final String MENU_PARTNER_SEPARATOR = "26,33,29";
		// -- }
	}

	interface UploadPath {
		/**
		 * 파일업로드 경로
		 */
		
		public final String DEFAULT_SAVE_ROOT	= "attach";
		
		public final String UPLOAD_FREE_TIME_FOLDER 			= "FREE_TIME"; 			//[0]
		public final String UPLOAD_BAD_COMPLAINT_REQ_FOLDER 	= "BAD_COMPLAINT_REQ"; 	//[1]
		public final String UPLOAD_BULLETIN_FOLDER 				= "BULLETIN"; 			//[2]
		public final String UPLOAD_BBS_FOLDER 					= "BBS"; 				//[3]
		public final String UPLOAD_CARD_DOC_FOLDER 				= "CARD_DOC"; 			//[4]
		public final String UPLOAD_CAR_CHANGE_FOLDER 			= "CAR_CHANGE"; 		//[5]
		public final String UPLOAD_FINE_FOLDER 					= "FINE"; 				//[6]
		public final String UPLOAD_STAT_ACCT_FOLDER 			= "STAT_ACCT"; 			//[7]
		public final String UPLOAD_TINT_FOLDER 					= "TINT"; 				//[8]
		public final String UPLOAD_USERS_FOLDER 				= "USERS"; 				//[9]
		public final String UPLOAD_YEAR_JUNGSAN_FOLDER 			= "YEAR_JUNGSAN"; 		//[10]
		public final String UPLOAD_ALLOT_FOLDER 				= "ALLOT"; 				//[11]
		public final String UPLOAD_APPRSL_FOLDER 				= "APPRSL"; 			//[12]
		public final String UPLOAD_FINE_DOC_FOLDER 				= "FINE_DOC"; 			//[13]
		public final String UPLOAD_LC_SCAN_FOLDER 				= "LC_SCAN"; 			//[14]
		public final String UPLOAD_PIC_RESRENT_ACCID_FOLDER 	= "PIC_RESRENT_ACCID"; 	//[15]
		public final String UPLOAD_PAY_FOLDER 					= "PAY"; 				//[16]
		public final String UPLOAD_STAT_CMP_FOLDER 				= "STAT_CMP"; 			//[17]
		public final String UPLOAD_CLS_ETC_FOLDER 				= "CLS_ETC"; 			//[18]
		public final String UPLOAD_BANK_ACC_FOLDER 				= "BANK_ACC"; 			//[19]
		public final String UPLOAD_PROP_BBS_FOLDER 				= "PROP_BBS"; 			//[20]
		public final String UPLOAD_SUI_ETC_FOLDER 				= "SUI_ETC"; 			//[21]
		public final String UPLOAD_ACTN_SCAN_FOLDER 			= "ACTN_SCAN"; 			//[22]
		public final String UPLOAD_KNOW_HOW_FOLDER 				= "KNOW_HOW"; 			//[23]
		public final String UPLOAD_OVER_TIME_FOLDER 			= "OVER_TIME"; 			//[24]
		public final String UPLOAD_SC_SCAN_FOLDER 				= "SC_SCAN"; 			//[25]
		public final String UPLOAD_CAR_OFF_EMP_FOLDER 			= "CAR_OFF_EMP"; 		//[26]
		public final String UPLOAD_CONSIGNMENT_FOLDER 			= "CONSIGNMENT"; 		//[27]
		public final String UPLOAD_LEND_BANK_FOLDER 			= "LEND_BANK"; 			//[28]
		public final String UPLOAD_PARTS_ORDER_FOLDER 			= "PARTS_ORDER"; 		//[29]
		public final String UPLOAD_COMMI_FOLDER 				= "COMMI"; 				//[30]
		public final String UPLOAD_COOPERATION_FOLDER 			= "COOPERATION"; 		//[31]
		public final String UPLOAD_PIC_ACCID_FOLDER 			= "PIC_ACCID"; 			//[32]
		public final String UPLOAD_SERVICE_FOLDER 				= "SERVICE"; 			//[33]				
		public final String UPLOAD_WORK_FOLDER					= "work";
		public final String UPLOAD_ANC_FOLDER					= "anc";
		public final String UPLOAD_ACCID_FOLDER					= "accid";
		public final String UPLOAD_ACCT_FOLDER					= "acct";
		public final String UPLOAD_SCAN_FOLDER					= "scan";
		public final String UPLOAD_DOC_SETTLE_FOLDER 			= "DOC_SETTLE";
		public final String UPLOAD_OFF_DOC 						= "OFF_DOC";
		public final String UPLOAD_ESTI_SPE                     = "ESTI_SPE";	//[37]
		public final String UPLOAD_CAR_COL                      = "CAR_COL";	//[38]
		public final String UPLOAD_INSUR						= "INSUR";		//[39]
		// --  }
	}
	
	interface Common {
		public final String FMS3_COOKIE_VALUE 	= "FILE_SERVER_FMS3";
		public final String contentCodeName		= "contentCode";
		public final String contentSeqName		= "contentSeq";
	}

}
