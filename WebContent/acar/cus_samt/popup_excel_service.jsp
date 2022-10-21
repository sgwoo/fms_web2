<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_excel_service.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=euc-kr"><!-- 엑셀로 저장시 한글깨짐 해결해줌 -->
<head><title>FMS</title>


<script language='JavaScript' src='/include/common.js'></script>

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	Vector sers = cs_db.getServNewJList(acct, gubun1, s_year, s_mon, s_kd, t_wd, sort, asc);
	int ser_size = sers.size();
			
	long amt8_old = 0;
	long amt[] 	= new long[13];
	
	String acct_nm = "";
	
	if (acct.equals("000620")) {
		acct_nm = "MJ모터스";
	} else if ( acct.equals("002105")  ) {
		acct_nm = "부경자동차정비";
	} else if ( acct.equals("000286")  ) {
		acct_nm = "정일현대";	
	} else if ( acct.equals("006858")  ) {
		acct_nm = " 오토크린";		
//	} else if ( acct.equals("007603")  ) {
//		acct_nm = " 노블래스";			
	} else if ( acct.equals("001816")  ) {
		acct_nm = " 삼일정비";
	} else if ( acct.equals("007897")  ) {
		acct_nm = " 1급금호자동차정비";	
	} else if ( acct.equals("008462")  ) {
		acct_nm = " 성서현대정비";	
	} else if ( acct.equals("008507")  ) {
		acct_nm = " 상무현대정비";			
	} else if ( acct.equals("006490")  ) {
		acct_nm = " 상무1급";				
	} else if ( acct.equals("009290")  ) {
		acct_nm = " 신엠제이모터스";					
	} else if ( acct.equals("010424")  ) {
		acct_nm = " 강서현대서비스";						
	} else if ( acct.equals("002033")  ) {
		acct_nm = " 충정로점현대자동차";						
	} else if ( acct.equals("010757")  ) {
		acct_nm = " SNP모터스";	
	} else if ( acct.equals("010779")  ) {
		acct_nm = " 엠파크서비스 ";			
	} else if ( acct.equals("010651")  ) {
		acct_nm = " 강서모터스 ";	
	} else if ( acct.equals("012005")  ) {
		acct_nm = " 아마존모터스 ";		
	} else if ( acct.equals("012730")  ) {
		acct_nm = " 통진서비스 ";			
	} else {
		acct_nm = "현대카독크";
	}	
	
	long r_labor = 0;
%>


<table border="0" cellspacing="0" cellpadding="0" width=1462>
  <tr> 
    <td colspan="2" align="left"><font face="굴림" size="2" > 
      <b>&nbsp; * &nbsp;<%=acct_nm%>&nbsp;거래현황 ( <%=s_year%>년&nbsp;<%=s_mon%>월 제 <%=t_wd%>장 ) </b> </font></td>
  </tr>
  <tr> 
    <td colspan="2" align="right"><font face="굴림" size="2" > 
      출력일자: <%=AddUtil.getDate()%>&nbsp;</font></td>
  </tr>
  
  <tr id='tr_title' style='position:relative;z-index:1' >
   <td class='line' width='502' id='td_title' style='position:relative;'><table border="1" cellspacing="1" cellpadding="0" width='502'>
       <tr> 
            <td width='53'   rowspan=2 class='title' align=center style="font-size : 9pt;">연번</td>
            <td width='97'  rowspan=2 class='title' align=center style="font-size : 9pt;">차량번호</td>
            <td width='110'  rowspan=2 class='title' align=center style="font-size : 9pt;">차명</td>
            <td width='60'    rowspan=2 class='title' align=center style="font-size : 9pt;">구분</td>
            <td width='61'   rowspan=2 class='title' align=center style="font-size : 9pt;">입고일자</td>
	   <td width='61'   rowspan=2 class='title' align=center style="font-size : 9pt;">출고일자</td>
	    <td width='61'   rowspan=2 class='title' align=center style="font-size : 9pt;"> 등록일자</td>
         
       </tr>
      </table></td>
		<td class='line' width='960'>
	
	    <table border="1" cellspacing="1" cellpadding="0" width='960'  >
         <tr>
         	 <td width='60'  rowspan=2 class='title' align=center style="font-size : 9pt;">담당자</td>
 	 <td width='150' rowspan=2 class='title' align=center style="font-size : 9pt;">계약자</td>			  		
           <td width='190' rowspan=2 class='title' align=center style="font-size : 9pt;">적요</td>
         <!--   <td  class="title" colspan=4 align=center style="font-size : 9pt;">정비내역</td> -->
            <td  class="title" colspan=5 align=center style="font-size : 9pt;">지급내역</td>
            <td  class="title"  colspan=2  align=center style="font-size : 9pt;">면책금</td>         
            <td width='100'  class="title" rowspan=2 align=center style="font-size : 9pt;">&nbsp;&nbsp;&nbsp;비고&nbsp;&nbsp;&nbsp;</td>
           </tr>
           
           <tr>    
                <td width='80' class='title' align=center style="font-size : 9pt;">공임</font></td>
                <td width='80' class='title' align=center style="font-size : 9pt;">부품</font></td>
                <td width='70' class='title' align=center style="font-size : 9pt;">D/C</font></td>
                <td width='70' class='title' align=center style="font-size : 9pt;">선입금</font></td>
                <td width='80' class='title' align=center style="font-size : 9pt;">소계</font></td>
                 <td width='70' class='title' align=center style="font-size : 9pt;">청구</font></td>
                 <td width='70' class='title' align=center style="font-size : 9pt;">해지시</font></td>
               
          </tr>
        </table>
		</td>
		
	</tr>

<%	if(ser_size > 0){%>
	<tr>
	  <td class='line' width='502' id='td_con' style='position:relative;'> <table border="1" cellspacing="1" cellpadding="0" width='502'>
          <%for(int i = 0 ; i < ser_size ; i++){
				Hashtable exp = (Hashtable)sers.elementAt(i); %>
         <tr> 
                <td width='53' align='center' style="font-size : 9pt;"><%=i+1%>
                <%if(exp.get("USE_YN").equals("N")){%>
              	(해약) 
              	<%}%>
                </td>
                <td width='97' align='center' style="font-size : 9pt;">&nbsp;<%=exp.get("CAR_NO")%></td>
                <td width='110' align='left' style="font-size : 9pt;">&nbsp;<%=Util.subData(String.valueOf(exp.get("CAR_NM")), 9)%></td>
                <td width='60' align='center' style="font-size : 9pt;"><%=exp.get("SERV_ST")%></td> 
                <td width='61'  align=center   style="font-size : 9pt;"><%=exp.get("IPGODT")%></td>
                <td width='61'  align=center  style="font-size : 9pt;"><%=exp.get("CHULGODT")%></td>
                 <td width='61' align=center   style="font-size : 9pt;"><%=exp.get("REG_DT")%></td>
         </tr>
        <%		}%>
         <tr> 
            <td colspan="7" class=star align=center style="font-size : 9pt;">합계&nbsp;</td>
         </tr>
      </table></td>	
   
   <td class='line' width='960'>			
			  <table border="1" cellspacing="1" cellpadding="0" width="960" >
             <%for(int i = 0 ; i < ser_size ; i++){
				Hashtable exp = (Hashtable)sers.elementAt(i);
					// 사고시 당사 과실비율
				 int our_fault = 0;
				 String ch_fault = "";
				 String ch_acc_st = "";
				 
				 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
				
				 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
				
				 while(token2.hasMoreTokens()) {
						ch_fault = token2.nextToken().trim();	 
						ch_acc_st = token2.nextToken().trim();	 			
				 }
				 our_fault = AddUtil.parseInt (ch_fault);
				 
				 //소송인경우 소송의 결재비율로 
				 if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  { 
					 our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER"))) ;
				 }
				 
				 long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //부품
				 
					 
				 if ( exp.get("SERV_ST").equals("자차")){   			
				        v_amt = v_amt * our_fault/100;   				 
				 }  
				 
				  //일단위 절사   -20120223
				   v_amt  =AddUtil.l_th_rnd_long(v_amt);
				 
				 long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //공임
				 
			 	 long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); //공임
				 
				 v_dc_sup_amt  =AddUtil.l_th_rnd_long(v_dc_sup_amt);
				   
				  
				if ( exp.get("SERV_ST").equals("자차")){   		
				        v_labor = v_labor * our_fault/100;
				
   				 }  
			   	 
				 long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
				 
				 
				 int v_cnt =  AddUtil.parseInt((String)exp.get("CNT"));
				 
				 long v_cust_amt =  AddUtil.parseLong((String)exp.get("CUST_AMT"));
				
				 long v_ext_amt =  AddUtil.parseLong((String)exp.get("EXT_AMT"));
				 
				  long v_cls_amt =  AddUtil.parseLong((String)exp.get("CLS_AMT"));
				 
				 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
				 
				 String item1 = "";
				 String item2 = "";
				   
			     while(token1.hasMoreTokens()) {
				
				  	 item1 = token1.nextToken().trim();	//
				   	 item2 = token1.nextToken().trim();	//부품
								
			     }	
			     
			     
			    //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
				  
			    if  ( i == 0 ) {
			   		amt[8]   = v_c_labor + v_labor ;	
			   	}else {
			   		amt[8]  = amt[8]  + v_labor;	
			   	}
			   
			    int c_rate = 0;
			    int vc_rate = 0;
				int jj_amt = 0;
				int jjj_amt = 0;
				   			 
				long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
					
					// 2008년 8월 까지는 dc 적용, 그후 dc 적용 없음
					/*
				if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
					 c_rate = 0;
				} else {
					if ( amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				         c_rate = 10;
				    } else if ( amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         c_rate = 15;
				    } else if ( amt[8] >30000000 ) {
				         c_rate = 20;   
				    } else {
				         c_rate = 0;   
				    }           
				}
				*/
				
				// 2008년 8월 4차까지는 dc 적용, 그후 dc 적용 없음
			//	if ( s_dt == 200808 &&  String.valueOf(exp.get("SSS_ST")).equals("5") ){
			//		 c_rate = 0;  
			//	}   			    
			       
			    if ( AddUtil.parseInt(t_wd) > 1  && i==0) {
			        amt8_old = v_c_labor;  //1회차이상인 경우
			    }
			   
			   /* 
			   if (v_labor > 0 ) {
				    //최초 dc 구간에 걸리는 경우 
				    if ( amt8_old < 10000000  && amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				     	 jj_amt = amt[8] - 10000000;
				    } else if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jj_amt = amt[8] - 20000000;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				         jj_amt = amt[8] - 30000000;
				    }
				    
				    
				    // 2천마원, 3천만원 최초 구간인 경우 금액 산정
				    if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jjj_amt = (v_labor - jj_amt) * 10/100;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				          jjj_amt = (v_labor - jj_amt) * 15/100;
				    }
			    }
			    */
			    
			       	// 2008년 8월 4차까지는 dc 적용, 그후 dc 적용 없음
			       	/*
			    if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
			        vc_rate = 0;
			    } else {
				    if(v_labor != 0  )	vc_rate = v_labor*c_rate/100;
				    if(jj_amt !=0 )	  vc_rate = (jj_amt*c_rate/100) + jjj_amt;
			    } 
					*/
							     
			     amt8_old =  amt[8];
			     
			     r_labor = AddUtil.l_th_rnd_long(  v_labor - vc_rate);
			     
			     
			     
			%>
              <tr>
                <td width='60' align='center' style="font-size : 9pt;">&nbsp;<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
			  	<td width='150' align='left' style="font-size : 9pt;">&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 10)%></td>
  			    <td width='190' align='left' style="font-size : 9pt;">&nbsp;
  			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
  			    <%=item2 %>
			  	<%}else{%>
			   <%=Util.subData(item2, 10)%>&nbsp;외 <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;건		  
			  	<%}%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(r_labor)%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_amt)%></td>
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_dc_sup_amt)%></td>
                 <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_ext_amt)%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(r_labor + v_amt - v_dc_sup_amt - v_ext_amt)%></td>           
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%></td>          
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%></td>          
                <td width='100' align='right' style="font-size : 9pt;">&nbsp;</td>
              </tr>
               <%	
               
             		amt[0]   = amt[0] + AddUtil.l_th_rnd_long( v_labor );
             		amt[1]   = amt[1] + v_amt;
             		amt[2]   = amt[2] + v_amt + v_labor;
             		amt[3]   = amt[3] + vc_rate;
             		
             		amt[4]   = amt[4] +r_labor;
             		amt[5]   = amt[5] + v_amt;
             		amt[6]   = amt[6] + r_labor + v_amt - v_dc_sup_amt - v_ext_amt;
             		amt[7]   = amt[7] + v_cust_amt;
             		amt[10]   = amt[10] + v_ext_amt;
             		amt[11]   = amt[11] + v_dc_sup_amt;
             		
             		amt[12]   = amt[12] + v_cls_amt;
      			               
               	}%>
         	  <tr> 
                <td class=star colspan=3></td>
			
                <td width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[4] )%></font></td>
                <td width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[5] )%></font></td>
               <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[11] )%></font></td>
               <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[10] )%></font></td>
                <td width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[6] )%></font></td>           
                <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[7] )%></font></td>
               <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[12] )%></font></td>
                <td width='100' align='right' style="font-size : 9pt;">&nbsp;</font></td>
              </tr>
            </table>
		</td>
	</tr>	
		
	
<%	} %>
</table>

<%
//명진 total
String  mj_value = cs_db.getServMJ_PTOT(acct, s_year, s_mon, t_wd);
long ch_labor_amt=0;
long ch_amt_amt=0;
long ch_dc_amt_amt=0;
long ch_dc_amt=0;
long ch_ext_amt=0;

StringTokenizer token3 = new StringTokenizer(mj_value,"^");
				
while(token3.hasMoreTokens()) {
	ch_labor_amt = AddUtil.parseLong(token3.nextToken().trim());	 
	ch_amt_amt = AddUtil.parseLong(token3.nextToken().trim());	 
	ch_dc_amt_amt = AddUtil.parseLong(token3.nextToken().trim());	
	ch_dc_amt = AddUtil.parseLong(token3.nextToken().trim());	
	ch_ext_amt = AddUtil.parseLong(token3.nextToken().trim());				
}

long vat1 = 0;
long vat2 = 0;
vat1 = (ch_labor_amt - ch_dc_amt_amt +ch_amt_amt - ch_dc_amt -ch_ext_amt)*10/100;
vat2 = (amt[0]  - amt[3] + amt[1] -amt[11]   -amt[10] )*10/100;
//부가세 일단위 절사 - 20120223
   vat1  =AddUtil.l_th_rnd_long(vat1);
   vat2  =AddUtil.l_th_rnd_long(vat2);
   
%>
<br>
<table border="0" cellspacing="0" cellpadding="0" width=1392>	
   <tr> 	   
	     <td><table border="1" cellpadding="0" cellspacing="1">
	          <tr>
	            <td height="25"  rowspan=2 class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;구분</font></td>
	            <td class=star  colspan=5 align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;지급금액</font></td>
	            <td rowspan=2  class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;VAT</font></td> 
	            <td rowspan=2 class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;총지급액</font></td>
	          </tr>
	          <tr>	        
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;공임</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;부품</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;D/C</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;선입금</font></td>	        	  
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;소계</font></td>	              
	          </tr>	          
	          <tr> 
	            <td height="25"  class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;전장</font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt - ch_dc_amt_amt)%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_amt_amt)%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_dc_amt)%></font></td>	        
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_ext_amt)%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt - ch_dc_amt_amt +ch_amt_amt  - ch_dc_amt - ch_ext_amt )%></font></td>	  
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(vat1)%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt - ch_dc_amt_amt + ch_amt_amt - ch_dc_amt - ch_ext_amt  + vat1  )%></font></td>
	          </tr>
	          <tr> 
	            <td height="25"  class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;당해</font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[0]-  amt[3])%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[1])%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[11])%></font></td>
	             <td   class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[10])%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[0]- amt[3]+amt[1] - amt[11] - amt[10] )%></font></td>	  
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(vat2)%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(amt[0]-  amt[3]+amt[1] - amt[11] - amt[10] + vat2 )%></font></td>
	          </tr>
	          <tr>
	            <td height="25"  class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;누계</font></td>
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt +amt[0]- ch_dc_amt_amt - amt[3] )%></font></td>
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_amt_amt + amt[1] )%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_dc_amt + amt[11] )%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_ext_amt + amt[10] )%></font></td>
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt +amt[0]- ch_dc_amt_amt - amt[3]+ ch_amt_amt + amt[1] - ch_dc_amt - amt[11]  - ch_ext_amt - amt[10]  )%></font></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal( vat1 + vat2 )%></font></td>
	            <td class=star align='right' style="font-size : 9pt;"><font face="굴림">&nbsp;<%=Util.parseDecimal(ch_labor_amt +amt[0] - ch_dc_amt_amt - amt[3] + ch_amt_amt + amt[1]-  ch_dc_amt - amt[11]  -  ch_ext_amt - amt[10]  + vat1 + vat2  )%></font></td>
	          </tr>
	          </table></td>
	          
	          <td><table border="0" cellpadding="0" cellspacing="1">
	          <tr>
	            <td height="25"  rowspan=2 class=star align='center' style="font-size : 9pt;"></td>
	            <td class=star  colspan=4 align='center' style="font-size : 9pt;"></td>   
	          </tr>	                
	          </table></td>
	       <!--   
	          <td><table border="1" cellpadding="0" cellspacing="1">
	          <tr>
	            <td height="25"  rowspan=2 class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;결재</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;담당</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;팀장</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;부장</font></td>
	            <td class=star align='center' style="font-size : 9pt;"><font face="굴림">&nbsp;사장</font></td>            
	          </tr>	                   
	          <tr> 
	            <td height="50"  class=star align='center' style="font-size : 9pt;"></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림"></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림"></td>
	            <td  class=star align='right' style="font-size : 9pt;"><font face="굴림"></td>  
	          </tr>
	          </table></td>
	          -->
	</tr>
</table>

</body>
</html>

