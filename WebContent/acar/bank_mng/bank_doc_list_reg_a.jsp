<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
			
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	String cmd			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //롯데오토리스에서만 사용 (202204)
	
	int count = 0;
	int cnt = 0;
	boolean flag = true;
	
	String value0[]  = request.getParameterValues("seq_no");
	String value1[]  = request.getParameterValues("amt4"); //대출원금
	String value2[]  = request.getParameterValues("amt5"); //취득세
	String value3[]  = request.getParameterValues("ss_amt"); //담보설정금액
	String value4[]  = request.getParameterValues("amt3"); //구매가격
	
	int  seq_no = 0;  //연번
	int  amt3 = 0;  // 구매가격
	int  amt4 = 0;  //대출원금
	int  amt5 = 0;  //취득세
	int  amt6 = 0;  //담보설정액
	int dam_amt = 0;
	float  dam_f_amt = 0;  //담보설정액	
		
	for(int i=0 ; i < scd_size ; i++){
								
		seq_no = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);
			
		amt4 = value1[i]	==null?0 :AddUtil.parseDigit(value1[i]);
		amt5 = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]);
			
	//	System.out.println("대출금액 건별 수정="+  amt4 +":"+ amt5);	
	
		amt6 = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]);  //담보설정
		amt3 = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]);
				
                    
                     // 삼성카드는 20% 담보 
			if ( 		bank_id.equals("0018") ) {			
			        dam_amt =  FineDocDb.getDamAmt(amt4, 0);		
			} else if ( bank_id.equals("0002")    ) {			
			        dam_amt =  FineDocDb.getDamAmt1(amt3);			  
			} else if  ( bank_id.equals("0044")  )  {
			        dam_amt = 		amt4+ amt5 ;
			} else if  ( bank_id.equals("0058")  )  {
				    dam_amt =	1000000;   //담보설정액
			} else if  ( bank_id.equals("0025")  ||  bank_id.equals("0004") )  {  //전북은행, 부산은행, 산업은행, 롯데오토리스 , 국민은행(11/06)
				    dam_amt =0;   //담보설정액	
			} else if  ( bank_id.equals("0041")  ||  bank_id.equals("0055") ||  bank_id.equals("0069") ||  bank_id.equals("0102")   )  {  //하나캐피탈 담보 50%->20% 변경, 현대캐피탈 0%->20%, 세람저축(0072) , bnk캐피탈(0102)
			             dam_amt =	 (amt4 + amt5) /5 ;
			} else if  ( bank_id.equals("0011")  ||  bank_id.equals("0108") )  {  //현대캐피탈 담보 20%->50% 변경 , 현대커머셜(0108)
	             dam_amt =	 (amt4 + amt5) /2 ;	
		    } else if (  bank_id.equals("0076")  ||  bank_id.equals("0081") ||  bank_id.equals("0074") ||  bank_id.equals("0084")   ) {		//, 현대저축(0081) - 구입가격 50%
		        		dam_amt =  FineDocDb.getDamAmt2(amt3);	
		    } else if (  bank_id.equals("0101") || bank_id.equals("0114")  ) {		//, 제이티저축(0101) - 대출 가격 50% , 롯데카드(0114) -202104부터
		        		dam_amt =  FineDocDb.getDamAmt2(amt4);	    
		    } else if (  bank_id.equals("0059")  ) {		// hk저축(0059) - 대출 가격 30%
		        		dam_amt =  FineDocDb.getDamAmt3(amt4);	  
		    } else if (  bank_id.equals("0072")  ) {		// 세림저축(0072) - 대출 가격 10% 
        				dam_amt =  FineDocDb.getDamAmtRate(10, amt4);  
		    } else if (  bank_id.equals("0093")  ) {		// 롯데오토리스(0093) - 대출 가격 70% - 담보율 사용 (롯데오토리스만 :202204 )
		        		dam_amt =  FineDocDb.getDamAmtRate(cltr_rat, amt4);  
		    } else if (  bank_id.equals("0033") || bank_id.equals("0029")    ) {		// 전북은행(0033) , 광주은행(0029) - 대출 가격 120%
	        		dam_amt =  FineDocDb.getDamAmtRate(120, amt4);
		    } else if (  bank_id.equals("0028")  ) {		// 수협은행(0028) - 대출 가격 110%
        		dam_amt =  FineDocDb.getDamAmtRate(110, amt4); 		  
			} else if  ( bank_id.equals("0064")    )  {  //메리츠  - 대출액 천단위에서 절상			
			        dam_amt =  FineDocDb.getDamAmt4(amt4+amt5, 3);			   		 
			} else if  ( bank_id.equals("0065")  ||  bank_id.equals("0038")  ||  bank_id.equals("0057") )  {  //한화생명보험 - 대출액 100% , kt캐피탈(100% - 20140724), 롯데캐피탈(0038>20140820 100%)  , ibk캐피탈(0057, 50억한도소진시, 202012)
			         dam_amt =  amt4;	
		//	} else if  ( bank_id.equals("0028")    )  {  //하나저축은행 , 수협(20170412) - 차량가격  100%
		//	         dam_amt =  amt3;		
			} else if  ( bank_id.equals("0078")  || bank_id.equals("0080")  || bank_id.equals("0087") ||  bank_id.equals("0103") )  {  //kb캐피탈(0078) 담보 10% , 오케이저축(0080), 오케이아프로(0087), IBK캐피탈(0057) , kb국민카드(0103)
		             dam_amt =	 (amt4 + amt5) /10 ;		          
		    } else if (  bank_id.equals("0001") ||  bank_id.equals("0046") ) { //하나은행/		   //우리카드(0046)/   
		    	dam_amt =  FineDocDb.getDamAmtRate(60, amt4);  //2022-01-25  수정 (계산으로)
		      //  	  dam_amt =  amt6;		    				           	         
		    } else if (  bank_id.equals("0083") ) { //페퍼저축은행
          	       	 dam_amt =  FineDocDb.getDamAmt7(amt3);		  
		    } else if (  bank_id.equals("0115") ) { //금화저축은행
     	       	 dam_amt =  FineDocDb.getDamAmtRound4(amt3, 30);
		    } else if (  bank_id.equals("0087") ) { //kb저축은행
      	       	  	 dam_amt =  FineDocDb.getDamAmt10(amt3);            
            } else if (  bank_id.equals("0089") || bank_id.equals("0111") ) { //인성저축 , 한화저축(0111)
          	       	 dam_amt =  FineDocDb.getDamAmt11(amt3);          	
          	} else if (  bank_id.equals("0076") || bank_id.equals("0081") ||  bank_id.equals("0074")  ||  bank_id.equals("0090")   ) {		//, aj인베스트	- 구입가격 50%  	  
          		     dam_amt =  FineDocDb.getDamAmt2(amt3);            
            } else {
                    dam_amt = 	 (amt4 + amt5) /2 ;
            } 
                 		                 		
              //   System.out.println("대출금액 건별 수정담보="+ bank_id + ":"  + (amt4 + amt5) /5  );	
                           		 
		if(!FineDocDb.updateFineDocAmt4(doc_id, seq_no,  amt3,  amt4, amt5, dam_amt))	count += 1;		
				
	}

	
//	flag = FineDocDb.updateFineDocList(doc_id, gov_id);			
	
	if(cmd.equals("d")){

		FineDocListBn.setDoc_id(doc_id);
		FineDocListBn.setRent_l_cd(rent_l_cd);
		
		cnt = FineDocDb.bank_doc_list_del(FineDocListBn);

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
<script>
<% if(!cmd.equals("d")){%>
<%		if(count != 0){%>
		alert("에러발생!");
<% } else {%>	
		alert("정상적으로 처리되었습니다.");
		parent.opener.location.reload();
		parent.window.close();	

<%		}%>

<%}else{%>
<% if(cnt != 0){%>
		alert("한건 삭제 되었습니다.");
		parent.parent.location.reload();
<%}else{%>
		alert("에러 에러 에러");
<%}
}%>

</script>
</body>
</html>

