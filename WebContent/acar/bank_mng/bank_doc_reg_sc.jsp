<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	String lend_int = request.getParameter("lend_int")==null?"0.0":request.getParameter("lend_int"); //대출이율
	String lend_cond = request.getParameter("lend_cond")==null?"1":request.getParameter("lend_cond"); //상환조건
	
	int count = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "06");
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function bank_doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.fund_yn.value 	= sh_fm.fund_yn.value;
	
		fm.bank_id.value 	= sh_fm.bank_id.value;
		fm.bank_nm.value 	= sh_fm.bank_nm.value;		
		
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.mng_pos.value 	= sh_fm.mng_pos.value;
		fm.title.value 	= sh_fm.title.value;	
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		fm.app_doc1.value 	= sh_fm.app_doc1.value;
		fm.app_doc2.value 	= sh_fm.app_doc2.value;
		fm.app_doc3.value 	= sh_fm.app_doc3.value;
		fm.app_doc4.value 	= sh_fm.app_doc4.value;
		fm.app_doc5.value 	= sh_fm.app_doc5.value;
		
		fm.cltr_rat.value 	= sh_fm.cltr_rat.value;
		fm.cltr_amt.value 	= sh_fm.cltr_amt.value;	
		
		fm.off_id.value 	= sh_fm.off_id.value;
		fm.seq.value 	= sh_fm.seq.value;
			
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); return; }		
		if(fm.bank_id.value == '')		{ alert('수신기관을 선택하십시오.'); return; }		
		if(fm.bank_nm.value == '')		{ alert('수신기관을 선택하십시오.'); return; }

		if(fm.size.value == '0')		{ alert('계약을 조회 하십시오.'); return; }
		

		//롯데오토리스인 경우는 근저당설정을 입력받아야 함  
		if(fm.bank_id.value == '0093')	{  
			if ( fm.cltr_rat.value  == '') { alert('근저당설정을 입력하십시오.'); return; }
		}

		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "bank_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>

</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='doc_dt' value=''>
<input type='hidden' name='fund_yn' value=''>
<input type='hidden' name='bank_id' value=''>
<input type='hidden' name='bank_nm' value=''>
<input type='hidden' name='mng_dept' value=''>
<input type='hidden' name='mng_nm' value=''>
<input type='hidden' name='mng_pos' value=''>
<input type='hidden' name='title' value=''>
<input type='hidden' name='h_mng_id' value=''>
<input type='hidden' name='b_mng_id' value=''>
<input type='hidden' name='app_doc1' value=''>
<input type='hidden' name='app_doc2' value=''>
<input type='hidden' name='app_doc3' value=''>
<input type='hidden' name='app_doc4' value=''>
<input type='hidden' name='app_doc5' value=''>
<input type='hidden' name='cltr_rat' value=''>
<input type='hidden' name='cltr_amt' value=''>
<input type='hidden' name='exp_dt' value='<%=exp_dt%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='lend_cond' value='<%=lend_cond%>'>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='off_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                     <td class='title' width="6%">연번</td>
                    <td width='13%' class='title'>상호</td>
                    <td width='8%' class='title'>기간(월)</td>
                    <td width='12%' class='title'>월대여료</td>
                    <td width='12%' class='title'>총대여료</td>
                    <td width='14%' class='title'>차종</td>
                    <td width='11%' class='title'>차량번호</td>
                    <td width='12%' class='title'>구입가격</td>
                    <td width='12%' class='title'>대출금액</td>
                            
                </tr>
<% 	
	//선택리스트
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_bank_id="";

	float loan_amt = 0;
	int loan_amt1 = 0;
		
	float loan_a_amt = 0;
	float loan_b_amt = 0;
	
	int loan_a_amt1 = 0;
	int loan_b_amt1 = 0;
	
	float  tax_amt = 0;  //취득세 -- 모닝 취득세 제외
	float  tax_a_amt = 0;  //취득세
	float  tax_b_amt = 0;  //취득세
	int    tax_amt1 = 0; //취득세
	int    tax_a_amt1 = 0; //취득세
	int    tax_b_amt1 = 0; //취득세
	
	int loan_amt1_tot = 0; //대출금액 합계
	int  ecar_pur_amt = 0; //구매보조금 
	int  car_f_amt = 0;   //우리카드(0046)일때만 사용  	
	int  car_dc_amt = 0;   //우리카드(0046)일때만 사용  	
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_bank_id = token1.nextToken().trim();	 		
								
		}		
				
		Hashtable loan = cdb.getLoanListExcel(ch_m_id, ch_l_cd, ch_c_id);
		
		// 추후 데이타 화 
		//롯데캐피탈 , 외환캐피탈, 효성캐피탈, 우리파이낸셜, KT 캐피탈, IBK캐피탈, HK저축은행, 무림캐피탈, 우리금융저축은행, 수협은행, SBi 3 저축은행(0068) ,한국씨티그룹캐피탈(0069), 세람저축은행(0072), SBi 4 저축은행(0073) , 하나저축(0074), aj인베스트(0076)
		// kb캐피탈(0078), 현대저축(0081), 페퍼저축(0083), 흥국저축(0084) ,kb저축(0085) , 남양저축(0088), 인성저축(0089), 신한저축은행(0090), 한신저축은행(0094), 오투저축(0100) , 제이티저축(0101) , bnk캐피탈(0102) , kb국민카드(0103), 스타저축(0104)
		//한화저축(0111) , ibk저축(0113), 롯데카드 (0114) , 금화저축(0115)
		//대출금액 
		if (	   ch_bank_id.equals("0038") || ch_bank_id.equals("0040") || ch_bank_id.equals("0039") || ch_bank_id.equals("0051") || ch_bank_id.equals("0057") || ch_bank_id.equals("0059")  
				|| ch_bank_id.equals("0058") || ch_bank_id.equals("0060") || ch_bank_id.equals("0028") || ch_bank_id.equals("0068") || ch_bank_id.equals("0069") || ch_bank_id.equals("0072")
				|| ch_bank_id.equals("0073") || ch_bank_id.equals("0074") || ch_bank_id.equals("0076") || ch_bank_id.equals("0077") || ch_bank_id.equals("0078") || ch_bank_id.equals("0081")  
				|| ch_bank_id.equals("0083") || ch_bank_id.equals("0084") || ch_bank_id.equals("0085") || ch_bank_id.equals("0088") || ch_bank_id.equals("0089") || ch_bank_id.equals("0090")
				|| ch_bank_id.equals("0092") || ch_bank_id.equals("0094") || ch_bank_id.equals("0100") || ch_bank_id.equals("0101") || ch_bank_id.equals("0102") || ch_bank_id.equals("0103")
				|| ch_bank_id.equals("0104") || ch_bank_id.equals("0110") || ch_bank_id.equals("0111") || ch_bank_id.equals("0113") || ch_bank_id.equals("0114") || ch_bank_id.equals("0115") ) { 
		         loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		} else if (ch_bank_id.equals("0009") || ch_bank_id.equals("0001") || ch_bank_id.equals("0003") || ch_bank_id.equals("0099") || ch_bank_id.equals("0086") || ch_bank_id.equals("0010") 
				|| ch_bank_id.equals("0079") || ch_bank_id.equals("0056") || ch_bank_id.equals("0091") || ch_bank_id.equals("0116") || ch_bank_id.equals("0093") ) { //신한캐피탈 or 신한은행 or 하나은행 or 우리은행 , 한국캐피탈(0099) , 오릭스캐피탈(0086-201808 변경) , 메리츠,kdb캐피탈(20191119변경 ) , 애큐온캐피탈(20200212변경) , db캐피탈(202009변경), 롯데오토리스(0093)
				 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		} else if (ch_bank_id.equals("0055") || ch_bank_id.equals("0064") || ch_bank_id.equals("0065") || ch_bank_id.equals("0075") || ch_bank_id.equals("0080") || ch_bank_id.equals("0082") 
				|| ch_bank_id.equals("0087")   ) { //산은캐피탈 , BS캐피탈, 메리츠, 한화생명보험, 농심캐피탈 , 메리츠캐피탈(0079) , ok저축(0080), 대신저축(0082) , orix , 오케이아프로(0087),  롯데오토리스(0093) , 
				 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1");
		} else if (ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") || ch_bank_id.equals("0002") || ch_bank_id.equals("0063") || ch_bank_id.equals("0118") ) { //두산캐피탈, nh캐피탈 , 하나캐피탈 , 외환은행, DGB캐피탈, 메리츠 , 우리금융캐피탈
				 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) - (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))*10/100 ); 
				 loan_a_amt1 = (int) loan_a_amt;
			     loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);		     
	    } else if (ch_bank_id.equals("0018") ) { //삼성카드 :20160318 80->90%, 산업은행(0037) 20160712
	           	 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;	
	    } else if (ch_bank_id.equals("0109") ) { //렌터카공제조합(0109 
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  80/100;
	    } else if (ch_bank_id.equals("0026")  ) { //대구은행 공급가만 대출
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;                  
	    } else if (ch_bank_id.equals("0004") || ch_bank_id.equals("0025") ) { //국민은행  ,  부산은행   	
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 90/100;                          
	    } else if (ch_bank_id.equals("0037") || ch_bank_id.equals("0005") ) { //산업은행 --20180508  - 20190507-80% 신한은행 (20200602-80%)
					//		loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1") *  87/100;	      
	         	 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) *  80/100;
	    } else if (ch_bank_id.equals("0046") ) { //우리카드(0046) - 차량가격의 80% - 202104		 
     			// loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_F_AMT"))) *  80/100;  
     			car_f_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_F_AMT")));  //차량가격   
		 		car_dc_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_DC_AMT")));  //dc금액    
		 		loan_a_amt1 = car_f_amt - car_dc_amt;		 
		 		loan_a_amt = AddUtil.parseFloat(Integer.toString(loan_a_amt1)) *  80/100;  		 			 		
		 		loan_a_amt1 = (int) loan_a_amt;
		 		loan_a_amt1 = AddUtil.th_rnd(loan_a_amt1); 
	        		        	
	    } else if ( ch_bank_id.equals("0033") ) { //광주은행	, 전북은행  --공급가100%
				 loan_a_amt =  AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;
				 loan_a_amt1 = (int) loan_a_amt;
	             loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		
		} else if (ch_bank_id.equals("0011") || ch_bank_id.equals("0108") ) { //현대캐피탈(0011) , 현대커머셜(0108) - 구입가격 대출
				 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     
				 loan_a_amt1 = (int) loan_a_amt;	      	
	       //      loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		 //20170912 수정 
	             loan_a_amt1 = AddUtil.hun_th_rnd(loan_a_amt1); 		 //20170912 수정 
		} else if (ch_bank_id.equals("0029") ) { //광주은행(0029)  구입가격 대출 - 2021년 
			 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;	 
			 loan_a_amt1 = (int) loan_a_amt;	      	
            loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		          
	    //  	} else if ( ch_bank_id.equals("0056") ) { //kt구입가격 대출
		//			loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     	           	  	
	    } else {
	             loan_amt =  0;
	   	}
			
		loan_amt1 = (int) loan_amt;
		
		if (	   ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") || ch_bank_id.equals("0002") || ch_bank_id.equals("0011")  || ch_bank_id.equals("0108") 
	 			|| ch_bank_id.equals("0063") || ch_bank_id.equals("0029") || ch_bank_id.equals("0033") || ch_bank_id.equals("0046") || ch_bank_id.equals("0118") ) {
				loan_amt1 = loan_a_amt1;
		} else if (ch_bank_id.equals("0026")   ) { 
				loan_amt1 = loan_amt1;
		} else if (ch_bank_id.equals("0037")   ) { 	 //삼성카드제외 - 20191212
	//	} else if (ch_bank_id.equals("0018") || ch_bank_id.equals("0037")   ) { 		
				loan_amt1 = AddUtil.th_rnd(loan_amt1);
	//	} else if (ch_bank_id.equals("0037") ) { 
	//		loan_amt1 = AddUtil.hun_th_rnd(loan_amt1);
		} else {
				loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
	    } 
        
		//구매보조금이 있는 경우 제외함 - 20210401
		ecar_pur_amt = AddUtil.parseDigit(String.valueOf(loan.get("ECAR_PUR_AMT")));  //구매보조금   
       	loan_amt1 = loan_amt1 - ecar_pur_amt;    
			
        int ep = 0;
        int ep3 = 0;
        int ep4 = 0;
                    
        int ep1 = 0;
        int ep2 = 0;
              	
        //산은, 두산, 하나, 삼성카드, 무림,dgb, 메리츠, orix  는  은 취득세 - 산은제외 (20130911) , 메리츠제외(0079) - 20160217  - 20181210 하나피탈(0041) 제외 , 현대캐피탈(20211018) - 리스자금인 경우
        if ( ch_bank_id.equals("0043") || ch_bank_id.equals("0058") || ch_bank_id.equals("0063") || ch_bank_id.equals("0064") || ch_bank_id.equals("0011")  ) {   

			ep1 = String.valueOf(loan.get("CAR_NM")).indexOf("모닝");
			ep2 = String.valueOf(loan.get("CAR_NM")).indexOf("스파크");
			
			ep   = String.valueOf(loan.get("CAR_NO")).indexOf("허");   // 2: 허가 있으면
			ep3 = String.valueOf(loan.get("CAR_NO")).indexOf("하");
			ep4 = String.valueOf(loan.get("CAR_NO")).indexOf("호");
			
            //현대캐피탈_리스인 경우에 한해서 취득세 ( 2%*2 로 계산 (취등록세를 각각 계산 - 도합 4% -20211021))
		    if ((String.valueOf(loan.get("CAR_NM")).equals("모닝") ||  String.valueOf(loan.get("CAR_NM")).equals("스파크")) && (ep == 2 ||   ep3 == 2 ||ep4 == 2  ) ) {
	        	 tax_amt = (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))/ AddUtil.parseFloat("1.1") )* 2/100;
		      	 tax_amt1 = (int) tax_amt;   
		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);
		     }  else if (ep1 == -1 &&  ep2 == -1) {		    	
	        	 tax_amt = (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))/ AddUtil.parseFloat("1.1") )* 2/100;
		      	 tax_amt1 = (int) tax_amt;   
		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);		    		 
		     }  else{   	 
	             tax_amt1 = 0;
	         }  
				    
        }
		
		loan_amt1_tot += loan_amt1;
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>
                	<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
        			<input type='hidden' name='rent_mng_id' value='<%=ch_m_id%>'>
        			<input type='hidden' name='rent_l_cd' value='<%=ch_l_cd%>'>			
        			<input type='hidden' name='rent_s_cd' value=''>
        			<input type='hidden' name='firm_nm' value='<%=loan.get("FIRM_NM")%>'>
        			<input type='hidden' name='fee_amt' value='<%=loan.get("FEE_AMT")%>'>
        			<input type='hidden' name='tot_fee_amt' value='<%=loan.get("TOT_FEE_AMT")%>'>
        			<input type='hidden' name='car_amt' value='<%=loan.get("CAR_AMT")%>'>
        			<input type='hidden' name='loan_amt' value='<%=loan_amt1%>'>
       				<input type='hidden' name='tax_amt' value='<%=tax_amt1%>'>
        			<input type='hidden' name='con_mon' value='<%=loan.get("CON_MON")%>'>	
        			<input type='hidden' name='car_f_amt' value='<%=loan.get("CAR_F_AMT")%>'> <!--  0046일때만 사용  -->		
        			<input type='hidden' name='car_dc_amt' value='<%=loan.get("CAR_DC_AMT")%>'> <!--  0046일때만 사용  -->		
                    <td><span title='<%=loan.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(loan.get("FIRM_NM")), 7)%></td>
                    <td><%=loan.get("CON_MON")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("FEE_AMT"))%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("TOT_FEE_AMT"))%></td>
                    <td><%=Util.subData(String.valueOf(loan.get("CAR_NM")), 8)%></td>
                    <td><%=loan.get("CAR_NO")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("CAR_AMT"))%></td>
                    <td align=right><%=Util.parseDecimal(loan_amt1)%></td>
                </tr>

<%		count++;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
				<tr>
					<td colspan="8" class='title'>합계</td>
					<td align=right><%=Util.parseDecimal(loan_amt1_tot)%>원 </td>
				</tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    <a href='javascript:bank_doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
