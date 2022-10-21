<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //롯데오토리스에서만 사용 (202204)
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String doc_id =  FineDocDb.getFineGovNoNext("총무");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn");
	
	int count = 0;
	boolean flag = true;
	boolean flag2 = true;
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(cmd.equals("m")){	
		// 대출신청시 총무팀장 및 대출, 입금, 출금 담당자에게 메세지 전송------------------------------------------------------------------------------------------
		
		String bank_nm = request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
		String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
		long amt_tot = request.getParameter("amt_tot")==null?0:Util.parseDigitLong(request.getParameter("amt_tot"));
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		String sub 		= "대출신청시 각 담당자에게 메신저로 통보";
		String cont 	= bank_nm+" 대출금 "+Util.parseDecimalLong(amt_tot)+"원 "+vio_dt+ " 입금예정입니다";	
		String url 		= "/acar/bank_mng/bank_doc_mng_frame.jsp";	 
		String target_id = "";  				
		CdAlertBean msg = new CdAlertBean();
		
		String xml_data = "";
		
		//총무팀장에게 메세지 보내기
			
		target_id =nm_db.getWorkAuthUser("CMS관리"); //안보국, 김태우(2004005), 입금담당자
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <TARGET>2004005</TARGET>";
		xml_data += "    <TARGET>2000002</TARGET>";//안팀장님
		xml_data += "    <TARGET>2013002</TARGET>";//조현준
		xml_data += "    <TARGET>2017003</TARGET>";//이준석
	
		//	xml_data += "    <TARGET>2006007</TARGET>";//
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(대출관련)---------------------"+target_bean.getUser_nm());
		
		
	//메세지 전송 끝
	}else if(!cmd.equals("m")){
	if(count == 0){
		//공문 테이블
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setFund_yn		(request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn"));  //리스자금 유무 
		FineDocBn.setGov_id		(bank_id);
		FineDocBn.setMng_dept		(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_st		(request.getParameter("lend_cond")==null?"":request.getParameter("lend_cond")); //상환조건
		FineDocBn.setFilename		(request.getParameter("lend_int")==null?"0.0":request.getParameter("lend_int")); //대출금리 - 대출신청시 사용함
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos		(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setTitle		(request.getParameter("title")==null?"":request.getParameter("title"));	
		FineDocBn.setH_mng_id		(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id		(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
		FineDocBn.setApp_doc1		(request.getParameter("app_doc1")==null?"N":request.getParameter("app_doc1"));
		FineDocBn.setApp_doc2		(request.getParameter("app_doc2")==null?"N":request.getParameter("app_doc2"));
		FineDocBn.setApp_doc3		(request.getParameter("app_doc3")==null?"N":request.getParameter("app_doc3"));
		FineDocBn.setApp_doc4		(request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4"));
		FineDocBn.setApp_doc5		(request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5"));
		FineDocBn.setEnd_dt		(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt")); //대출 실행일자
		
		FineDocBn.setOff_id		(request.getParameter("off_id")==null?"":request.getParameter("off_id")); //대출 담당자
		FineDocBn.setSeq		(request.getParameter("seq")==null?0:AddUtil.parseDigit(request.getParameter("seq"))); //대출 
		
		FineDocBn.setCltr_rat		(request.getParameter("cltr_rat")==null?"":request.getParameter("cltr_rat")); //근저당설정율
		FineDocBn.setCltr_amt		(request.getParameter("cltr_amt")==null?0:AddUtil.parseDigit(request.getParameter("cltr_amt"))); //설정건당금액
		
		if  (  bank_id.equals("0065")    )  {  //한화생명보험 - 첨부파일5 없음
			FineDocBn.setApp_doc5("N");
		}
		
		flag = FineDocDb.insertFineDoc(FineDocBn);

		//공문 리스트
		String car_mng_id[]  = request.getParameterValues("car_mng_id");
		String rent_mng_id[] = request.getParameterValues("rent_mng_id");
		String rent_l_cd[]   = request.getParameterValues("rent_l_cd");
		String rent_s_cd[]   = request.getParameterValues("rent_s_cd");
		String firm_nm[] 	 = request.getParameterValues("firm_nm");
		String fee_amt[] 	 = request.getParameterValues("fee_amt");
		String tot_fee_amt[] = request.getParameterValues("tot_fee_amt");
		String car_amt[] 	 = request.getParameterValues("car_amt");
		String loan_amt[] 	 = request.getParameterValues("loan_amt");	
		String tax_amt[] 	 = request.getParameterValues("tax_amt");	//현대캐피탈(0011)의 리스자금인 경우 4%취득세 (2%+ 2% 로 계산 )
		String con_mon[] 	 = request.getParameterValues("con_mon");	
		String s_car_f_amt[] 	 = request.getParameterValues("car_f_amt");	 //우리카드(0046)일때만 사용  		
		String s_car_dc_amt[] 	 = request.getParameterValues("car_dc_amt");	 //우리카드(0046)일때만 사용  		
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		
		long loan_amte = 0;
		long tax_amte = 0;
		long tot_amte = 0;
		
		int dam_amt = 0;
		float  dam_f_amt = 0;  //담보설정액	
		
		int  amt3 = 0;  //차량가격
		int  amt4 = 0;  //대출액
		int  amt5 = 0;  //취득세
		int  car_f_amt = 0;   //우리카드(0046)일때만 사용  		
		int  car_dc_amt = 0;   //우리카드(0046)일때만 사용  		
		String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
		
		for(int i=0; i<size; i++){
				
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i + 1);
			FineDocListBn.setRent_mng_id	(rent_mng_id[i]);
			FineDocListBn.setRent_l_cd		(rent_l_cd[i]);
			FineDocListBn.setRent_s_cd		(rent_s_cd[i]);
			FineDocListBn.setFirm_nm		(firm_nm[i]==null?"":firm_nm[i]);
						
			FineDocListBn.setAmt1			(fee_amt[i]==null?0:AddUtil.parseDigit(fee_amt[i]));  //대여료
			FineDocListBn.setAmt2			(tot_fee_amt[i]==null?0:AddUtil.parseDigit(tot_fee_amt[i]));  // 총대여료
			FineDocListBn.setAmt3			(car_amt[i]==null?0:AddUtil.parseDigit(car_amt[i]));     // 차량가격
			
			amt3 = car_amt[i]	==null?0 :AddUtil.parseDigit(car_amt[i]);
			amt4 = loan_amt[i]	==null?0 :AddUtil.parseDigit(loan_amt[i]);
			
			amt5 = tax_amt[i]	==null?0 :AddUtil.parseDigit(tax_amt[i]);
			
			car_f_amt = s_car_f_amt[i]	==null?0 :AddUtil.parseDigit(s_car_f_amt[i]);  //우리카드(0046)일때만 사용  		
			car_dc_amt = s_car_dc_amt[i]	==null?0 :AddUtil.parseDigit(s_car_dc_amt[i]);  //우리카드(0046)일때만 사용  		
			
			if ( bank_id.equals("0011") ) {	  //현대캐피탈_리스인 경우에 한해서 취득세 ( 2%*2 로 계산 (취등록세를 각각 계산 - 도합 4% -20211021))
				if (fund_yn.equals("Y")) {
					amt5 = amt5 * 2;
				} else {
					amt5=0;
				}				
			}
			
			FineDocListBn.setAmt4			(amt4);   //대출액 
			FineDocListBn.setAmt5			(amt5);   //취득세 
																
			 // 삼성카드는 20% 담보 
			if ( bank_id.equals("0018") ) {			
			        dam_amt =  FineDocDb.getDamAmt(amt4, 0);
			    	FineDocListBn.setAmt6		( dam_amt );		
		//	} else if ( bank_id.equals("0037")    ) { //산은 - 20140324 부터 저당권설정없음			
		//	         FineDocListBn.setAmt6		(0 );	    	
			} else if (  bank_id.equals("0002")   ) {			
			        dam_amt =  FineDocDb.getDamAmt1(amt3);
			    	FineDocListBn.setAmt6		( dam_amt );	
			} else if  (  bank_id.equals("0044")   )  {  
			        FineDocListBn.setAmt6		(amt4+ amt5  );
			} else if  (  bank_id.equals("0058")  )  {
					FineDocListBn.setAmt6		(1000000);   //담보설정액
			} else if  (  bank_id.equals("0025") ||  bank_id.equals("0004") )  {  //전북은행, 부산은행 , 국민은행(11/06)
					FineDocListBn.setAmt6		(0);   //담보설정액	
			} else if  (  bank_id.equals("0041") ||  bank_id.equals("0055")  ||  bank_id.equals("0069")  ||  bank_id.equals("0102") ||   bank_id.equals("0118") )  {  //하나캐피탈 담보 50%->20% 변경, 현대캐피탈 0%->20%, bs캐피탈 50%->20%, 한국씨티그룹캐피탈, 세람저축(0072) , bnk캐피탈(0102)
			        FineDocListBn.setAmt6		( (amt4 + amt5) /5 );	
			} else if  (  bank_id.equals("0011") ||  bank_id.equals("0108") )  {  //현대캐피탈 담보 20%->50% 변경
		         	FineDocListBn.setAmt6		( (amt4 + amt5) /2 );				
		    } else if (  bank_id.equals("0076")  ||  bank_id.equals("0081")  ||  bank_id.equals("0074")  ||  bank_id.equals("0090") ||  bank_id.equals("0084")  ) {		// aj인베스트 - 구입가격의 50% , 하나저축(0074), 유진저축(0081)  0084(흥국- 20190617)
		        	dam_amt =  FineDocDb.getDamAmt2(amt3);		      		
			    	FineDocListBn.setAmt6		( dam_amt );				
			} else if ( bank_id.equals("0101")  || bank_id.equals("0114")  ) {		// jt저축  - 대출금의  50% , 롯데카드(0114) -202104부터
		        	dam_amt =  FineDocDb.getDamAmt2(amt4);
		       		FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0072") ) {		// 세림저축   - 2019건부터 대출금의 10% ,
	        		dam_amt =  FineDocDb.getDamAmtRate(10, amt4);
	        		FineDocListBn.setAmt6		( dam_amt );		        		
		    } else if ( bank_id.equals("0093")  ) {		// 롯데오토리스   - 대축금의  70% - 2018건부터 대출금의 70% (리스자금인 경우) , 할부자금인 경우 (202204 - 대출금의 60%)
		        	dam_amt =  FineDocDb.getDamAmtRate(cltr_rat, amt4);
		        	FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0033") ||  bank_id.equals("0029")   ) {		// 전북은행(0033) , 광주은행(0029)  - 대축금의  120% - 2019건부터
			        dam_amt =  FineDocDb.getDamAmtRate(120, amt4); 
		       		FineDocListBn.setAmt6		( dam_amt );			       		    		
			} else if ( bank_id.equals("0059")  ) {		// hk저축  - 대축금의  30%
		        	dam_amt =  FineDocDb.getDamAmt3(amt4);
		       		FineDocListBn.setAmt6		( dam_amt );	
			} else if ( bank_id.equals("0064")     )  {  //메리츠  - 대출액 천단위에서 절상	
			        dam_amt =  FineDocDb.getDamAmt4(amt4+amt5 , 3);
			    	FineDocListBn.setAmt6		( dam_amt );					 
			} else if ( bank_id.equals("0065")  ||  bank_id.equals("0038")  ||  bank_id.equals("0057")  )  {  //한화생명보험 - 대출액 100% ,  kt케피탈(0056-> 20140724 담보100%) , 롯데캐피탈(0038>20140820 100%) , 흥국상호(0084) - , ibk캐피탈(0057) - 50억한도소진까지 202012)
			        dam_amt =  amt4;
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //취득세 
		//	} else if  (   bank_id.equals("0079"))  {  //메리츠캐피탈 
		//	      dam_amt =  FineDocDb.getDamAmt4( amt4+amt5  );
		//	//        dam_amt =  amt4+amt5;
		//	    	FineDocListBn.setAmt6		( dam_amt );				     	
		//	} else if  ( bank_id.equals("0028")  )  {  //하나저축은행 , 수협은행 (20170412) - 차량가격 100%  -- 대출금의 110% (20200901)
		//	        dam_amt =  amt3;
		//	    	FineDocListBn.setAmt6		( dam_amt );	
		//	    	FineDocListBn.setAmt5			(0);   //취득세 	
			 } else if ( bank_id.equals("0028") ) {		// 수협은행   - 대축금의  110% - 2019건부터
			        dam_amt =  FineDocDb.getDamAmtRate(110, amt4); 
		       		FineDocListBn.setAmt6		( dam_amt );	
		       		FineDocListBn.setAmt5			(0);   //취득세 						
		       		
			} else if ( bank_id.equals("0078") ||  bank_id.equals("0080")   ||  bank_id.equals("0087")  ||  bank_id.equals("0103")  )  {  //kb 캐피탈(00782) , ok저축(0080) , 효성캐피탈(0039) , IBK캐피탈(0057) , kb국민(0103) - 대출금의 10%
			         FineDocListBn.setAmt6		( (amt4 + amt5) /10 );	 
						         
			} else if ( bank_id.equals("0046") ) {		// 우리카드 (0046)  -차량가갹(car_f_amt)
				    dam_amt =  car_f_amt - car_dc_amt;
					FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0001") ) { //하나은행
		      	    dam_amt =  FineDocDb.getDamAmtRate(60, amt4); 
          		//	dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt4)) *60/100; 
          		//	dam_amt = (int)  dam_f_amt;
          		//	dam_amt =  AddUtil.th_rnd(dam_amt);	
          			FineDocListBn.setAmt6		( dam_amt );    
          	
			
		/*	} else if  (  bank_id.equals("0029")    )  {  //광주은행 - 차량구입공긍가의 50%
				dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *50/100; 
		        dam_amt = (int)  dam_f_amt;
     			dam_amt =  AddUtil.th_rnd(dam_amt);	
		    	FineDocListBn.setAmt6		( dam_amt );	
		    	FineDocListBn.setAmt5			(0);   //취득세 	    	
			    	
			  } else if (bank_id.equals("0029") ) { //광주은행 0  차량구입공급가의 50%
			            dam_f_amt = ( AddUtil.parseFloat(Integer.toString(amt3)) / AddUtil.parseFloat("1.1") )* 50/100;
			            dam_amt = (int)  dam_f_amt;
			            dam_amt =  FineDocDb.getDamAmt4(dam_amt+dam_amt , 3);
          		//	  dam_amt =  AddUtil.th_rnd(dam_amt);	
          			  FineDocListBn.setAmt6		( dam_amt );          	 */           
			  			  	         
			} else if  (  bank_id.equals("0083")    )  {  //페퍼저축은행 - 차량가격 70%
					dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *70/100; 
			        dam_amt = (int)  dam_f_amt;
          			dam_amt =  AddUtil.th_rnd(dam_amt);	
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //취득세 	
			} else if  (  bank_id.equals("0115")    )  {  //금화저축은행 - 차량가격 30%
				dam_amt =  FineDocDb.getDamAmtRound4(amt3, 30);
			//	dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *30/100; 
		     //   dam_amt = (int)  dam_f_amt;
      		//	dam_amt =  AddUtil.th_rnd(dam_amt);	
		    	FineDocListBn.setAmt6		( dam_amt );	
		    	FineDocListBn.setAmt5			(0);   //취득세 	    	
			    	
			} else if  (  bank_id.equals("0089") ||  bank_id.equals("0111")    )  {  //인성저축은행, 한화저축은행(0111) - 차량가격 10%
					dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *10/100; 
		         	dam_amt = (int)  dam_f_amt;
     				dam_amt =  AddUtil.th_rnd(dam_amt);	
		    		FineDocListBn.setAmt6		( dam_amt );	
		    		FineDocListBn.setAmt5			(0);   //취득세 	
		    	
			} else if  (  bank_id.equals("0085")   )  {  //KB저축은행,  - 차량가격10%
				//dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *50/100; 
			      //  dam_amt = (int)  dam_f_amt;
			       	dam_amt =  FineDocDb.getDamAmt10(amt3 );
          		//	dam_amt =  AddUtil.ml_th_rnd(dam_amt);	
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //취득세 				          		    		    		    	
			          		    		    		    	
	           }  else {  //  bank_id.equals("0039") -2021년부터 담보는 50%
	                FineDocListBn.setAmt6		( (amt4 + amt5) /2 );
	           } 
                 				
			FineDocListBn.setPaid_no		(con_mon[i]==null?"0":con_mon[i]);
			
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
			
			loan_amte += loan_amt[i]==null?0:AddUtil.parseDigit(loan_amt[i]) ;
			tax_amte += tax_amt[i]==null?0:AddUtil.parseDigit(tax_amt[i]) ;
			
		}
		tot_amte = loan_amte + tax_amte;

	}
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
<script>
<%if(cmd.equals("m")){%>
	alert("메세지가 정상적으로 전송되었습니다.");
		var fm = document.form1;	
		fm.action = "bank_doc_mng_frame.jsp";	
		fm.target = 'd_content';
		fm.submit();
<%}else{%>
	
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("정상적으로 처리되었습니다.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%	}else{%>
			alert("이미 등록된 문서번호입니다. 확인하십시오.");
//			parent.document.form1.bank_nm.focus();
<%	}%>
<%}%>
</script>
</body>
</html>

