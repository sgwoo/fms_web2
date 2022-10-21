<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, ax_hub.*, acar.coolmsg.*, acar.user_mng.*" %>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%
    /* ============================================================================== */
    /* =   PAGE : 지불 요청 및 결과 처리 PAGE                                       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   오류 발생시 아래의 주소에서 조회하시기 바랍니다.                         = */
    /* =   http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */
	
    /* ============================================================================== */
    /* =   환경 설정 파일 Include                                                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ※ 필수                                                                  = */
    /* =   테스트 및 실결제 연동시 site_conf_inc.jsp파일을 수정하시기 바랍니다.     = */
    /* = -------------------------------------------------------------------------- = */
%>
	<%@ page import="com.kcp.*" %>
	<%@ page import="java.net.URLEncoder"%>
	<%@ include file="/ax_hub/cfg/site_conf_inc.jsp"%>
<%
    /* = -------------------------------------------------------------------------- = */
    /* =   환경 설정 파일 Include END                                               = */
    /* ============================================================================== */
%>

<%!
    /* ============================================================================== */
    /* =   null 값을 처리하는 메소드                                                = */
    /* = -------------------------------------------------------------------------- = */
        public String f_get_parm( String val )
        {
          if ( val == null ) val = "";
          return  val;
        }
    /* ============================================================================== */
%>
<%
	request.setCharacterEncoding ( "euc-kr" ) ;
    /* ============================================================================== */
    /* =   01. 지불 데이터 셋업 (업체에 맞게 수정)                                  = */
    /* = -------------------------------------------------------------------------- = */
    	String g_conf_log_level = "3";                                                  // 변경불가
    	int    g_conf_tx_mode   = 0;                                                    // 변경불가
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   02. 지불 요청 정보 설정                                                  = */
    /* = -------------------------------------------------------------------------- = */
    	String req_tx         	= f_get_parm( request.getParameter( "req_tx"         ) ); 	// 요청 종류
    	String tran_cd        	= f_get_parm( request.getParameter( "tran_cd"        ) ); 	// 처리 종류
    /* = -------------------------------------------------------------------------- = */
    	String cust_ip        	= f_get_parm( request.getRemoteAddr()                  ); 	// 요청 IP
    	String ordr_idxx      	= f_get_parm( request.getParameter( "ordr_idxx"      ) ); 	// 쇼핑몰 주문번호
    	String good_name      	= f_get_parm( request.getParameter( "good_name"      ) ); 	// 상품명
    	String good_mny       	= f_get_parm( request.getParameter( "good_mny"       ) ); 	// 결제 총금액
    /* = -------------------------------------------------------------------------- = */
    	String res_cd         	= "";                                                     	// 응답코드
    	String res_msg        	= "";                                                     	// 응답 메세지
    	String tno            	= f_get_parm( request.getParameter( "tno"            ) ); 	// KCP 거래 고유 번호
    /* = -------------------------------------------------------------------------- = */
    	String buyr_name      	= f_get_parm( request.getParameter( "buyr_name"      ) ); 	// 주문자명
    	String buyr_tel1      	= f_get_parm( request.getParameter( "buyr_tel1"      ) ); 	// 주문자 전화번호
    	String buyr_tel2      	= f_get_parm( request.getParameter( "buyr_tel2"      ) ); 	// 주문자 핸드폰 번호
    	String buyr_mail      	= f_get_parm( request.getParameter( "buyr_mail"      ) ); 	// 주문자 E-mail 주소
    /* = -------------------------------------------------------------------------- = */
	String  mod_type      	= f_get_parm( request.getParameter( "mod_type"	     ) ); 	// 변경TYPE(승인취소시 필요)
    	String  mod_desc      	= f_get_parm( request.getParameter( "mod_desc"	     ) ); 	// 변경사유
    /* = -------------------------------------------------------------------------- = */
    	String use_pay_method 	= f_get_parm( request.getParameter( "use_pay_method" ) ); 	// 결제 방법
    	String bSucc          	= "";                                                     	// 업체 DB 처리 성공 여부
    /* = -------------------------------------------------------------------------- = */
    	String app_time       	= "";                                                     	// 승인시간 (모든 결제 수단 공통)
	String amount	      	= "";								// KCP 실제 거래금액         
	String total_amount   	= "0";								// 복합결제시 총 거래금액
    /* = -------------------------------------------------------------------------- = */
	String card_cd        	= "";                                                     	// 신용카드 코드
 	String card_name      	= "";                                                     	// 신용카드 명
    	String app_no         	= "";                                                     	// 신용카드 승인번호
    	String noinf          	= "";                                                     	// 신용카드 무이자 여부
    	String quota          	= "";                                                     	// 신용카드 할부개월
	String partcanc_yn    	= "";								// 부분취소 가능유무
	String card_bin_type_01 = "";								// 카드구분1
	String card_bin_type_02 = "";								// 카드구분2
    /* = -------------------------------------------------------------------------- = */
	String bank_name      	= "";                                                     	// 은행명
    	String bank_code      	= "";                                                     	// 은행코드
    /* = -------------------------------------------------------------------------- = */
    	String bankname       	= "";                                                     	// 입금 은행명
    	String depositor      	= "";                                                     	// 입금 계좌 예금주 성명
    	String account        	= "";                                                     	// 입금 계좌 번호
	String va_date	      	= "";								// 가상계좌 입금마감시간
    /* = -------------------------------------------------------------------------- = */
    	String pnt_issue      	= "";                                                     	// 결제 포인트사 코드
    	String pt_idno        	= "";                                                     	// 결제 및 인증 아이디
	String pnt_amount     	= "";                                                     	// 적립금액 or 사용금액
	String pnt_app_time   	= "";                                                     	// 승인시간
	String pnt_app_no     	= "";                                                     	// 승인번호
    	String add_pnt        	= "";                                                     	// 발생 포인트
	String use_pnt        	= "";                                                     	// 사용가능 포인트
	String rsv_pnt        	= "";                                                     	// 총 누적 포인트
    /* = -------------------------------------------------------------------------- = */
	String commid         	= "";								// 통신사코드
	String mobile_no      	= "";								// 휴대폰번호
    /* = -------------------------------------------------------------------------- = */
	String tk_shop_id	= f_get_parm( request.getParameter( "tk_shop_id"     ) ); 	// 가맹점 고객 아이디
	String tk_van_code	= "";								// 발급사코드
	String tk_app_no	= "";								// 승인번호
    /* = -------------------------------------------------------------------------- = */
    	String cash_yn        	= f_get_parm( request.getParameter( "cash_yn"        ) ); 	// 현금 영수증 등록 여부
    	String cash_authno    	= "";                                                     	// 현금 영수증 승인 번호
    	String cash_tr_code   	= f_get_parm( request.getParameter( "cash_tr_code"   ) ); 	// 현금 영수증 발행 구분
    	String cash_id_info   	= f_get_parm( request.getParameter( "cash_id_info"   ) ); 	// 현금 영수증 등록 번호
    
    
    	//아마존카 정보
    	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
    	
    	String am_ax_code   	= f_get_parm( request.getParameter( "am_ax_code"     ) ); 	// 인증번호
    	String am_m_tel   	= f_get_parm( request.getParameter( "am_m_tel"     ) ); 	// 인증번호
    	String am_card_kind   	= f_get_parm( request.getParameter( "am_card_kind"     ) ); 	// 카드종류
    	String am_card_sign   	= f_get_parm( request.getParameter( "am_card_sign"     ) ); 	// 카드회원성명
    	String am_card_rel   	= f_get_parm( request.getParameter( "am_card_rel"     ) ); 	// 계약자와의관계
    	
    	String tax_flag   	= f_get_parm( request.getParameter( "tax_flag"       ) ); 	// order에서 옵션
    	String comm_tax_mny   	= f_get_parm( request.getParameter( "comm_tax_mny"   ) ); 	// order에서 옵션
    	String comm_fee_mny   	= f_get_parm( request.getParameter( "comm_fee_mny"   ) ); 	// order에서 옵션
    	String comm_vat_mny   	= f_get_parm( request.getParameter( "comm_vat_mny"   ) ); 	// order에서 옵션
    	//String good_cd   	= f_get_parm( request.getParameter( "good_cd"        ) ); 	// order에서 옵션
    	//String good_expr   	= f_get_parm( request.getParameter( "good_expr"      ) ); 	// order에서 옵션
    	
    	boolean am_flag = true;
    					    	
    /* ============================================================================== */
    /* =   02. 지불 요청 정보 설정 END
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   03. 인스턴스 생성 및 초기화(변경 불가)                                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =       결제에 필요한 인스턴스를 생성하고 초기화 합니다.                     = */
    /* = -------------------------------------------------------------------------- = */
    	C_PP_CLI c_PayPlus = new C_PP_CLI();

    	c_PayPlus.mf_init( g_conf_home_dir, g_conf_gw_url, g_conf_gw_port, g_conf_key_dir, g_conf_log_dir, g_conf_tx_mode );
    	c_PayPlus.mf_init_set();
    /* ============================================================================== */
    /* =   03. 인스턴스 생성 및 초기화 END                                          = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   04. 처리 요청 정보 설정			                            = */
    /* = -------------------------------------------------------------------------- = */
    /* = -------------------------------------------------------------------------- = */
    /* =   04-1. 승인 요청 정보 설정                                                = */
    /* = -------------------------------------------------------------------------- = */
    	if ( req_tx.equals( "pay" ) )
    	{
            	c_PayPlus.mf_set_enc_data( f_get_parm( request.getParameter( "enc_data" ) ),
                                           f_get_parm( request.getParameter( "enc_info" ) ) );    


		//결제금액 위/변조 방지 기능 구현 소스 추가
		if(good_mny.trim().length() > 0){
		
			int ordr_data_set_no;
			
			ordr_data_set_no = c_PayPlus.mf_add_set("ordr_data");
			
			c_PayPlus.mf_set_us(ordr_data_set_no, "ordr_mony","1004");
		
		}                           
                                           
                                           
                                           
                                                                                          
    	}

    /* = -------------------------------------------------------------------------- = */
    /* =   04-2. 취소/매입 요청                                                     = */
    /* = -------------------------------------------------------------------------- = */
    	else if ( req_tx.equals( "mod" ) )
    	{
        	int     mod_data_set_no;

        	tran_cd = "00200000";
        	mod_data_set_no = c_PayPlus.mf_add_set( "mod_data" );

        	c_PayPlus.mf_set_us( mod_data_set_no, "tno",      request.getParameter( "tno"       ) ); // KCP 원거래 거래번호
       		c_PayPlus.mf_set_us( mod_data_set_no, "mod_type", mod_type                            ); // 원거래 변경 요청 종류
        	c_PayPlus.mf_set_us( mod_data_set_no, "mod_ip",   cust_ip                             ); // 변경 요청자 IP
        	c_PayPlus.mf_set_us( mod_data_set_no, "mod_desc", mod_desc			      ); // 변경 사유                        
    }
    /* = -------------------------------------------------------------------------- = */
    /* =   04. 처리 요청 정보 설정 END                                              = */
    /* = ========================================================================== = */


    /* = ========================================================================== = */
    /* =   05. 실행                                                                 = */
    /* = -------------------------------------------------------------------------- = */
    	if ( tran_cd.length() > 0 )
    	{
        	c_PayPlus.mf_do_tx( g_conf_site_cd, g_conf_site_key, tran_cd, cust_ip, ordr_idxx, g_conf_log_level, "0" );
		
		
	    	res_cd  = c_PayPlus.m_res_cd;  // 결과 코드
		res_msg = c_PayPlus.m_res_msg; // 결과 메시지
	}
    	else
    	{
        	c_PayPlus.m_res_cd  = "9562";
        	c_PayPlus.m_res_msg = "연동 오류|Payplus Plugin이 설치되지 않았거나 tran_cd값이 설정되지 않았습니다.";
    	}

    /* = -------------------------------------------------------------------------- = */
    /* =   05. 실행 END                                                             = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   06. 승인 결과 값 추출                                                    = */
    /* = -------------------------------------------------------------------------- = */
    	if ( req_tx.equals( "pay" ) )
    	{
        	if ( res_cd.equals( "0000" ) )
        	{
            		tno		= c_PayPlus.mf_get_res( "tno"	    ); 	// KCP 거래 고유 번호
            		amount	  	= c_PayPlus.mf_get_res( "amount"    ); 	// KCP 실제 거래 금액
	    		pnt_issue 	= c_PayPlus.mf_get_res( "pnt_issue" ); 	// 결제 포인트사 코드
	    
	    

    			/* = -------------------------------------------------------------------------- = */
    			/* =   06-1. 신용카드 승인 결과 처리                                            = */
    			/* = -------------------------------------------------------------------------- = */
            		if ( use_pay_method.equals( "100000000000" ) )
            		{
                		card_cd   		= c_PayPlus.mf_get_res( "card_cd"          ); 	// 카드사 코드
                		card_name 		= c_PayPlus.mf_get_res( "card_name"        ); 	// 카드사 명
                		app_time  		= c_PayPlus.mf_get_res( "app_time"         ); 	// 승인시간
                		app_no    		= c_PayPlus.mf_get_res( "app_no"           ); 	// 승인번호
                		noinf     		= c_PayPlus.mf_get_res( "noinf"            ); 	// 무이자 여부
                		quota     		= c_PayPlus.mf_get_res( "quota"            ); 	// 할부 개월 수
				partcanc_yn 		= c_PayPlus.mf_get_res( "partcanc_yn"      ); 	// 부분취소 가능유무
				card_bin_type_01 	= c_PayPlus.mf_get_res( "card_bin_type_01" ); 	// 카드구분1
				card_bin_type_02 	= c_PayPlus.mf_get_res( "card_bin_type_02" ); 	// 카드구분2

				/* = -------------------------------------------------------------- = */
                		/* =   06-1.1. 복합결제(포인트+신용카드) 승인 결과 처리             = */
                		/* = -------------------------------------------------------------- = */
                		if ( pnt_issue.equals( "SCSK" ) || pnt_issue.equals( "SCWB" ) )
                		{
                    			pt_idno      = c_PayPlus.mf_get_res( "pt_idno"      ); // 결제 및 인증 아이디
                    			pnt_amount   = c_PayPlus.mf_get_res( "pnt_amount"   ); // 적립금액 or 사용금액
	                		pnt_app_time = c_PayPlus.mf_get_res( "pnt_app_time" ); // 승인시간
	                		pnt_app_no   = c_PayPlus.mf_get_res( "pnt_app_no"   ); // 승인번호
	                		add_pnt      = c_PayPlus.mf_get_res( "add_pnt"      ); // 발생 포인트
                    			use_pnt      = c_PayPlus.mf_get_res( "use_pnt"      ); // 사용가능 포인트
                    			rsv_pnt      = c_PayPlus.mf_get_res( "rsv_pnt"      ); // 총 누적 포인트
					total_amount = amount + pnt_amount;		       // 복합결제시 총 거래금액
                		}
            		}

		}
	}

    /* = -------------------------------------------------------------------------- = */
    /* =   06. 승인 결과 처리 END                                                   = */
    /* ============================================================================== */



    
    /* = ========================================================================== = */
    /* =   07. 승인 및 실패 결과 DB 처리                                            = */
    /* = -------------------------------------------------------------------------- = */
    /* =      결과를 업체 자체적으로 DB 처리 작업하시는 부분입니다.                 = */
    /* = -------------------------------------------------------------------------- = */

	if ( req_tx.equals( "pay" ) )
    	{

    		/* = -------------------------------------------------------------------------- = */
    		/* =   07-1. 승인 결과 DB 처리(res_cd == "0000")                                = */
    		/* = -------------------------------------------------------------------------- = */
    		/* =        각 결제수단을 구분하시어 DB 처리를 하시기 바랍니다.                 = */
    		/* = -------------------------------------------------------------------------- = */
    		
        	if ( res_cd.equals( "0000" ) )
        	{
            		// 07-1-1. 신용카드
            		if ( use_pay_method.equals( "100000000000" ) )
            		{
            
		    		/* = -------------------------------------------------------------------------- = */
    				/* =   *** 아마존카 결재결과 등록                                               = */
    				/* = -------------------------------------------------------------------------- = */
    				/* =        정상 결재정보 등록, 총무팀 입금담당자 메시지발송                    = */
    				/* = -------------------------------------------------------------------------- = */
            			
				
				
            			
            			
            			
            			AxHubBean ax_bean = ax_db.getAxHubCase(am_ax_code);
            			
            							

				//결제요청
				ax_bean.setReq_tx		(req_tx				);	
				ax_bean.setOrdr_idxx		(ordr_idxx			);	
				ax_bean.setPay_method		(use_pay_method			);	
				ax_bean.setGood_name		(good_name			);	
				ax_bean.setGood_mny		(AddUtil.parseInt(good_mny)	);	
				ax_bean.setBuyr_name		(buyr_name			);	
				ax_bean.setBuyr_tel1		(buyr_tel1			);	
				ax_bean.setBuyr_tel2		(buyr_tel2			);	
				ax_bean.setBuyr_mail		(buyr_mail			);	
				ax_bean.setTax_flag		(tax_flag			);	
				ax_bean.setComm_tax_mny		(AddUtil.parseInt(comm_tax_mny)	);	
				ax_bean.setComm_fee_mny		(AddUtil.parseInt(comm_fee_mny)	);	
				ax_bean.setComm_vat_mny		(AddUtil.parseInt(comm_vat_mny)	);	
				//결제결과(신용카드결제분)
				ax_bean.setTno			(tno				);	
				ax_bean.setAmount		(AddUtil.parseInt(amount)	);	
				ax_bean.setCard_cd		(card_cd			);	
				ax_bean.setCard_name		(card_name			);	
				ax_bean.setApp_time		(app_time			);	
				ax_bean.setApp_no		(app_no				);					
				ax_bean.setNoinf		(noinf				);	
				ax_bean.setQuota		(quota				);	
				//아마존카 카드정보 추가저장
				ax_bean.setAm_card_kind		(am_card_kind			);
				ax_bean.setAm_card_sign		(am_card_sign			);
				ax_bean.setAm_card_rel		(am_card_rel			);
				
				
				if(ax_bean.getGood_mny() > ax_bean.getAmount() || ax_bean.getGood_mny() < ax_bean.getAmount()){
					am_flag = false;
				}else{
					am_flag = ax_db.updateAxHub(ax_bean);	
				}
				
				
				
				 				
				//계약담당자 및 입금담당자에게 메시지 통보
				
				
				Hashtable ht_target_user1 = new Hashtable();
				Hashtable ht_target_user2 = new Hashtable();
				Hashtable ht_target_user3 = new Hashtable();
				
				String am_sub 	= "신용카드결제통보";
				String am_cont 	= "["+good_name+" "+good_mny+"원] 신용카드 결제가 되었으니 확인하시기 바랍니다.";
				String am_url 	= "/fms2/ax_hub/ax_hub_c.jsp?am_ax_code="+am_ax_code;
				
				//연동번호발행자
				ht_target_user1 	= ax_db.getUserCase(ax_bean.getReg_id());
				
				//입금담당자
				ht_target_user2 	= ax_db.getUserCase(nm_db.getWorkAuthUser("입금담당"));
				
				//신용카드담당자
				ht_target_user3 	= ax_db.getUserCase(nm_db.getWorkAuthUser("세금계산서담당자"));
				
				String xml_data = "";
				
				xml_data =  "<COOLMSG>"+
  						"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+am_sub+"</SUB>"+
  						"    <CONT>"+am_cont+"</CONT>"+
  						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+am_url+"</URL>";
	
				//받는사람1
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user1.get("ID"))+"</TARGET>";
								
				//받는사람2
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user2.get("ID"))+"</TARGET>";
				
				//받는사람3
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user3.get("ID"))+"</TARGET>";

				//보낸사람
				xml_data += "    <SENDER>SYSTEM</SENDER>"+
	
		  				"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  						"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
  						"</COOLMSG>";
	
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
	
				boolean am_msg_flag = cm_db.insertCoolMsg(msg);
				
				//메모발송
				boolean mm_flag1 = ax_db.sendMemo("999999", String.valueOf(ht_target_user1.get("USER_ID")), am_sub, am_cont);
				boolean mm_flag2 = ax_db.sendMemo("999999", String.valueOf(ht_target_user2.get("USER_ID")), am_sub, am_cont);
				boolean mm_flag3 = ax_db.sendMemo("999999", String.valueOf(ht_target_user3.get("USER_ID")), am_sub, am_cont);												
				            			
            			
		    		/* = -------------------------------------------------------------------------- = */
    				/* =   *** 아마존카 결재결과 등록  END                                          = */
    				/* = -------------------------------------------------------------------------- = */
            			
            	
                		// 07-1-1-1. 복합결제(신용카드+포인트)
                		if ( pnt_issue.equals( "SCSK" ) || pnt_issue.equals( "SCWB" ) )
                		{
				
                		}
			}
			

		}

        	/* = -------------------------------------------------------------------------- = */
        	/* =   07-2. 승인 실패 DB 처리(res_cd != "0000")                                = */
        	/* = -------------------------------------------------------------------------- = */
		if( !"0000".equals ( res_cd ) )
		{
		
		
		}
	}	
    /* = -------------------------------------------------------------------------- = */
    /* =   07. 승인 및 실패 결과 DB 처리 END                                        = */
    /* = ========================================================================== = */



    /* = ========================================================================== = */
    /* =   08. 승인 결과 DB 처리 실패시 : 자동취소                                  = */
    /* = -------------------------------------------------------------------------- = */
    /* =      승인 결과를 DB 작업 하는 과정에서 정상적으로 승인된 건에 대해         = */
    /* =      DB 작업을 실패하여 DB update 가 완료되지 않은 경우, 자동으로          = */
    /* =      승인 취소 요청을 하는 프로세스가 구성되어 있습니다.                   = */
    /* =                                                                            = */
    /* =      DB 작업이 실패 한 경우, bSucc 라는 변수(String)의 값을 "false"        = */
    /* =      로 설정해 주시기 바랍니다. (DB 작업 성공의 경우에는 "false" 이외의    = */
    /* =      값을 설정하시면 됩니다.)                                              = */
    /* = -------------------------------------------------------------------------- = */

    	// 승인 결과 DB 처리 에러시 bSucc값을 false로 설정하여 거래건을 취소 요청
	bSucc = ""; 
	
	
	
	//아마존카 DB 처리 에러시 - 자동으로 승인취소요청 프로세스 구동		
	if(!am_flag) bSucc = "false"; 
	
	
	

	if (req_tx.equals("pay") )
	{
		if (res_cd.equals("0000") )
		{
            		if ( bSucc.equals("false") )
            		{
                		int mod_data_set_no;

                		c_PayPlus.mf_init_set();

                		tran_cd = "00200000";

                		mod_data_set_no = c_PayPlus.mf_add_set( "mod_data" );

                		c_PayPlus.mf_set_us( mod_data_set_no, "tno",      tno      ); // KCP 원거래 거래번호
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_type", "STSC"   ); // 원거래 변경 요청 종류
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_ip",   cust_ip  ); // 변경 요청자 IP
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_desc", "가맹점 결과 처리 오류 - 가맹점에서 취소 요청"  ); // 변경 사유

				c_PayPlus.mf_do_tx( g_conf_site_cd, g_conf_site_key, tran_cd, cust_ip, ordr_idxx, g_conf_log_level, "0" );

                		res_cd  = c_PayPlus.m_res_cd;								  // 결과 코드
                		res_msg = c_PayPlus.m_res_msg;								  // 결과 메시지
            		}
        	}
	}
	// End of [res_cd = "0000"]
    /* = -------------------------------------------------------------------------- = */
    /* =   08. 승인 결과 DB 처리 END                                                = */
    /* = ========================================================================== = */


    /* ============================================================================== */
    /* =   09. 폼 구성 및 결과페이지 호출                                           = */
    /* -----------------------------------------------------------------------------= */
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
        <title>*** KCP [AX-HUB Version] ***</title>
        <script type="text/javascript">
            function goResult()
            {
                var openwin = window.open( 'proc_win.html', 'proc_win', '' )
                document.pay_info.submit()
                openwin.close()
            }

            // 결제 중 새로고침 방지 샘플 스크립트
            function noRefresh()
            {
                /* CTRL + N키 막음. */
                if ((event.keyCode == 78) && (event.ctrlKey == true))
                {
                    event.keyCode = 0;
                    return false;
                }
                /* F5 번키 막음. */
                if(event.keyCode == 116)
                {
                    event.keyCode = 0;
                    return false;
                }
            }
            document.onkeydown = noRefresh ;
        </script>
    </head>

    <body onload="goResult()">
    <form name="pay_info" method="post" action="./result.jsp">
	<input type="hidden" name="site_cd"         value="<%= g_conf_site_cd	        %>">    <!-- 사이트 코드 -->
	<input type="hidden" name="req_tx"          value="<%= req_tx			%>">    <!-- 요청 구분 -->
        <input type="hidden" name="use_pay_method"  value="<%= use_pay_method	        %>">    <!-- 사용한 결제 수단 -->
        <input type="hidden" name="bSucc"           value="<%= bSucc			%>">    <!-- 쇼핑몰 DB 처리 성공 여부 -->

        <input type="hidden" name="res_cd"          value="<%= res_cd			%>">    <!-- 결과 코드 -->
        <input type="hidden" name="res_msg"         value="<%= res_msg			%>">    <!-- 결과 메세지 -->
        <input type="hidden" name="ordr_idxx"       value="<%= ordr_idxx		%>">    <!-- 주문번호 -->
        <input type="hidden" name="tno"             value="<%= tno			%>">    <!-- KCP 거래번호 -->
        <input type="hidden" name="good_mny"        value="<%= good_mny			%>">    <!-- 결제금액 -->
        <input type="hidden" name="good_name"       value="<%= good_name		%>">    <!-- 상품명 -->
        <input type="hidden" name="buyr_name"       value="<%= buyr_name		%>">    <!-- 주문자명 -->
        <input type="hidden" name="buyr_tel1"       value="<%= buyr_tel1		%>">    <!-- 주문자 전화번호 -->
        <input type="hidden" name="buyr_tel2"       value="<%= buyr_tel2		%>">    <!-- 주문자 휴대폰번호 -->
        <input type="hidden" name="buyr_mail"       value="<%= buyr_mail		%>">    <!-- 주문자 E-mail -->

	<input type="hidden" name="app_time"        value="<%= app_time			%>">	<!-- 승인시간 -->
	
	<!-- 신용카드 정보 -->
        <input type="hidden" name="card_cd"         value="<%= card_cd			%>">    <!-- 카드코드 -->
        <input type="hidden" name="card_name"       value="<%= card_name		%>">    <!-- 카드이름 -->
        <input type="hidden" name="app_no"          value="<%= app_no			%>">    <!-- 승인번호 -->
	<input type="hidden" name="noinf"	    value="<%= noinf			%>">    <!-- 무이자여부 -->
        <input type="hidden" name="quota"           value="<%= quota			%>">    <!-- 할부개월 -->
        <input type="hidden" name="partcanc_yn"     value="<%= partcanc_yn              %>">    <!-- 부분취소가능유무 -->
        <input type="hidden" name="card_bin_type_01" value="<%= card_bin_type_01        %>">    <!-- 카드구분1 -->
        <input type="hidden" name="card_bin_type_02" value="<%= card_bin_type_02        %>">    <!-- 카드구분2 -->



	<!-- 계좌이체 정보 -->
        <input type="hidden" name="bank_name"       value="<%= bank_name		%>">    <!-- 은행명 -->
        <input type="hidden" name="bank_code"       value="<%= bank_code		%>">    <!-- 은행코드 -->
	<!-- 가상계좌 정보 -->
        <input type="hidden" name="bankname"        value="<%= bankname			%>">    <!-- 입금 은행 -->
        <input type="hidden" name="depositor"       value="<%= depositor		%>">    <!-- 입금계좌 예금주 -->
        <input type="hidden" name="account"         value="<%= account			%>">    <!-- 입금계좌 번호 -->
        <input type="hidden" name="va_date"         value="<%= va_date			%>">    <!-- 가상계좌 입금마감시간 -->
	<!-- 포인트 정보 -->
	<input type="hidden" name="pnt_issue"	    value="<%= pnt_issue		%>">	<!-- 포인트 서비스사 -->
	<input type="hidden" name="pt_idno"	    value="<%= pt_idno			%>">	<!-- 결제 및 인증 아이디 -->
	<input type="hidden" name="pnt_app_time"    value="<%= pnt_app_time		%>">	<!-- 승인시간 -->
        <input type="hidden" name="pnt_app_no"      value="<%= pnt_app_no		%>">	<!-- 승인번호 -->
        <input type="hidden" name="pnt_amount"      value="<%= pnt_amount		%>">	<!-- 적립금액 or 사용금액 -->
        <input type="hidden" name="add_pnt"         value="<%= add_pnt			%>">	<!-- 발생 포인트 -->
        <input type="hidden" name="use_pnt"         value="<%= use_pnt			%>">	<!-- 사용가능 포인트 -->
        <input type="hidden" name="rsv_pnt"         value="<%= rsv_pnt			%>">	<!-- 총 누적 포인트 -->
	<!-- 휴대폰 정보 -->
        <input type="hidden" name="commid"          value="<%= commid			%>">	<!-- 통신사 코드 -->
        <input type="hidden" name="mobile_no"       value="<%= mobile_no		%>">	<!-- 휴대폰 번호 -->
        <!-- 상품권 정보 -->
        <input type="hidden" name="tk_van_code"     value="<%= tk_van_code		%>">	<!-- 발급사 코드 -->
        <input type="hidden" name="tk_app_no"       value="<%= tk_app_no		%>">	<!-- 승인 번호 -->
        <!-- 현금영수증 정보 -->
        <input type="hidden" name="cash_yn"         value="<%= cash_yn			%>">	<!-- 현금영수증 등록 여부 -->
        <input type="hidden" name="cash_authno"     value="<%= cash_authno		%>">	<!-- 현금 영수증 승인 번호 -->
        <input type="hidden" name="cash_tr_code"    value="<%= cash_tr_code		%>">	<!-- 현금 영수증 발행 구분 -->
        <input type="hidden" name="cash_id_info"    value="<%= cash_id_info		%>">	<!-- 현금 영수증 등록 번호 -->
        
        <input type="hidden" name="am_ax_code"        value="<%= am_ax_code   	%>" />   
        
    </form>
    </body>
</html>