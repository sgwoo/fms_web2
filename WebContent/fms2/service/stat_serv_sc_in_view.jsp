<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
		
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");	
	
	Vector vt = cr_db.getStatServSearch(gubun, brch_id, s_yy, s_mm, "all");
	int vt_size = vt.size();	
	

	int c_cnt[] 	= new int[2];	
	int tot_cnt[] 	= new int[3];
	int tot_amt[] 	= new int[3];
	
	int cnt1[] 	= new int[3];
	int cnt2[] 	= new int[3];
	int cnt3[] 	= new int[3];
	int cnt4[] 	= new int[3];
	int cnt5[] 	= new int[3];
	int cnt6[] 	= new int[3];
	int cnt7[] 	= new int[3];
	int cnt8[] 	= new int[3];
	int cnt9[] 	= new int[3];
	int cnt10[] 	= new int[3];
	int cnt11[] 	= new int[3];
	int cnt12[] 	= new int[3];
	int cnt13[] 	= new int[3];
	int cnt14[] 	= new int[3];
	int cnt15[] 	= new int[3];
	int cnt16[] 	= new int[3];
	int cnt17[] 	= new int[3];
	int cnt18[] 	= new int[3];
	int cnt19[] 	= new int[3];
	int cnt20[] 	= new int[3];
	
	int amt1[] 	= new int[3];
	int amt2[] 	= new int[3];
	int amt3[] 	= new int[3];
	int amt4[] 	= new int[3];
	int amt5[] 	= new int[3];
	int amt6[] 	= new int[3];
	int amt7[] 	= new int[3];
	int amt8[] 	= new int[3];
	int amt9[] 	= new int[3];
	int amt10[] 	= new int[3];
	int amt11[] 	= new int[3];
	int amt12[] 	= new int[3];
	int amt13[] 	= new int[3];
	int amt14[] 	= new int[3];
	int amt15[] 	= new int[3];
	int amt16[] 	= new int[3];
	int amt17[] 	= new int[3];
	int amt18[] 	= new int[3];
	int amt19[] 	= new int[3];
	int amt20[] 	= new int[3];
		
	String b_nm ="";						
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<script language='javascript'>

</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=2680>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width=260' id='td_title' style='position:relative;'> 
	        <table width='260' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="130" class=title style='height:70'>부서</td>
                    <td width="20" class=title>연번</td>
                    <td width="60" class=title>성명</td>
                    <td width="50" class=title>관리<br>대수</td>
                </tr>
            </table>
        </td>
	    <td class=line>
	        <table width='2420' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td colspan="40" class=title>정비업체별 거래현황</td>  
                </tr>
                <tr> 
                     <td  colspan=2 class=title>합계</td>
                    <td  colspan=2 class=title>스피드메이트</td>
                    <td  colspan=2 class=title>애니카랜드</td>
                    <td  colspan=2 class=title>명진</td>
                     <td  colspan=2 class=title>오토크린</td>  
                     <td  colspan=2 class=title>정일현대</td>
                     <td  colspan=2 class=title>부경</td>
                     <td  colspan=2 class=title>삼일정비</td>
                     <td  colspan=2 class=title>현대카독크</td>
                     <td  colspan=2 class=title>노블레스</td>
                     <td  colspan=2 class=title>1급금호자동차 </td>
                     <td  colspan=2 class=title>두꺼비카센타</td>
                     <td  colspan=2 class=title>티스테이션시청</td>
                     <td  colspan=2 class=title>티스테이션대전</td>     
                     <td  colspan=2 class=title>JT네트웍스</td>                 
                     <td  colspan=2 class=title>전국탁송</td>
                     <td  colspan=2 class=title>하이카콤부산</td>     
                     <td  colspan=2 class=title>하이카콤대전</td>            
                     <td  colspan=2 class=title>마스타자동차</td>                     
                     <td  colspan=2 class=title>성수자동차</td>   
                
                </tr>
                 <tr> 
                    <td width="50" class=title>건수</td>
                    <td width="90" class=title>금액</td>
        <%for (int i = 0 ; i <19; i++){%>           
                    <td width="40" class=title>건수</td>
                    <td width="80" class=title>금액</td>
        <% } %>
             
                            
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' width='260' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='260'>
              <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);  
    				
    				c_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("C0")));  //grand_total - 관리대수
    				
    				if (i == 0) {
    					b_nm = String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM"))  ;
    				}
    				
    				if ( b_nm.equals( String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM")) )) {				
    					c_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("C0"))); //sub_total
    				}	
    		         		
  				 if (!b_nm.equals(String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM"))  )) {
           	%> 			
  	      <tr> 
                    <td class=title align="center" colspan="3" height="20">소계</td>
                    <td class=title align="center" height="20" width="50"><%=Util.parseDecimal(c_cnt[0])%></td>
                </tr>
			<% 
					 b_nm = String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM")) ;
			 		 c_cnt[0] = 0;   
			 		 c_cnt[0] += AddUtil.parseInt(String.valueOf(ht.get("C0"))); //sub_total
		   		}              	
   			%>  
                <tr> 
                    <td align="center" width="130" height="20"><%=ht.get("DEPT_NM")%>- <%=ht.get("G_NM")%></td>
                    <td align="center" width="20"   height="20"><%=i+1%></td>
                    <td align="center" width="60"   height="20"><%=ht.get("USER_NM")%></td>                 
                    <td align="center" width="50"   height="20"><%=Util.parseDecimal(String.valueOf(ht.get("C0")))%></td>
                </tr>
         <% } %> 
      	     <tr> 
                    <td class=title align="center" colspan="3" height="20">소계</td>
                    <td class=title align="center" height="20"  width="50"><%=Util.parseDecimal(c_cnt[0])%></td>
                </tr>
		    
                <tr> 
                    <td class=title_p align="center" colspan="3" height="20">총계</td>
                    <td class=title_p align="center" height="20" width="50"><%=Util.parseDecimal(c_cnt[1])%></td>
                </tr>
            </table>
        </td>
	    <td class='line' width='2420'>
	        <table border="0" cellspacing="1" cellpadding="0" width='2420'>
          <%	
                            
          		tot_cnt[0] = 0;
          		tot_cnt[1] = 0;
          		
          		tot_amt[0] = 0;
          		tot_amt[1] = 0;
          		
          		for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);				
					
					 // grand total		
					cnt1[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
					cnt2[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
					cnt3[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));
					cnt4[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
					cnt5[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
					cnt6[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));
					cnt7[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));	
					cnt8[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));	
					cnt9[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));	
					cnt10[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));	
					cnt11[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));	
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));	
					cnt12[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt13[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt14[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));	
					cnt15[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));	
					cnt16[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));	
					cnt17[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));		
					cnt18[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));	
					cnt19[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));	
					cnt20[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));		
					tot_cnt[1]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));						
						
					amt1[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));					
					amt2[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));			
					amt3[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));			
					amt4[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));			
					amt5[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));			
					amt6[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));			
					amt7[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));			
					amt8[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));			
					amt9[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));			
					amt10[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));			
					amt11[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));			
					amt12[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));			
					amt13[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));		
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));			
					amt14[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));				
					amt15[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));				
					amt16[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));				
					amt17[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));			
					amt18[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));			
					amt19[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));			
					amt20[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));	
					tot_amt[1]+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));				
				 				    					  				   		 
	    				if (i == 0) {
	    					b_nm = String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM")) ;
	    				}
	    				
	    				if ( b_nm.equals(String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM")) )) {				
	    				
							cnt1[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
							cnt2[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
							cnt3[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));		
							cnt4[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
							cnt5[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
							cnt6[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));		
							cnt7[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));		
							cnt8[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));
							cnt9[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));		
							cnt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));		
							cnt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));		
							cnt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));		
							cnt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
							cnt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));		
							cnt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));		
							cnt16[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));		
							cnt17[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));		
							cnt18[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));		
							cnt19[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));		
							cnt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));	
							tot_cnt[0]	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));		
							
							//sub total		
							amt1[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
							amt2[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
							amt3[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));			
							amt4[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
							amt5[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
							amt6[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));	
							amt7[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));	
							amt8[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));	
							amt9[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));	
							amt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));		 	
							amt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));		 	
							amt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));		 	
							amt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));		 	
							amt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));		
							amt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));		
							amt16[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));		
							amt17[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));		
							amt18[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));		
							amt19[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));		
							amt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));
							tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));								
	    				}	
    		         		
  				    if (!b_nm.equals( String.valueOf(ht.get("DEPT_ID")) +  String.valueOf(ht.get("G_NM"))  )) {  				    
     	  	       	%> 
  		       		  		       		
           		   <tr> 
		           	  <td class=title style='text-align:right'  width="50"><%=Util.parseDecimal(tot_cnt[0])%></td>
		                    <td class=title style='text-align:right'  width="90"><%=Util.parseDecimal(tot_amt[0])%></td>                 	   
		                    <td class=title style='text-align:right'  height="20" width="40"><%=Util.parseDecimal(cnt1[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt1[0])%></td>
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt2[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt2[0])%></td>
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt3[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt3[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt4[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt4[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt5[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt5[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt6[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt6[0])%></td>		<!-- 부경-->
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt7[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt7[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt8[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt8[0])%></td>	<!--현대카독크 -->	
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt12[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt12[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt13[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt13[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt9[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt9[0])%></td>	
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt10[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt10[0])%></td>		
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt11[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt11[0])%></td>     
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt14[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt14[0])%></td>  <!-- jt네트웍스-->        
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt15[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt15[0])%></td>  <!--전국-->        
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt16[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt16[0])%></td>  <!-- 하이카콤부산-->        
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt17[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt17[0])%></td>  <!--하이카콤대전-->              
		                    <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt18[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt18[0])%></td>  <!--마스타자동차-->               
		                     <td class=title style='text-align:right'  width="40"><%=Util.parseDecimal(cnt19[0])%></td>
		                    <td class=title style='text-align:right'  width="80"><%=Util.parseDecimal(amt19[0])%></td>  <!--성수자동차-->                         
      																											
      	          </tr>
			<% 
						 b_nm = String.valueOf(ht.get("DEPT_ID")) + String.valueOf(ht.get("G_NM"))  ;
						 							
		 			 	c_cnt[0] 	= 0;
						cnt1[0] 	= 0;
						cnt2[0] 	= 0;
						cnt3[0] 	= 0;
						cnt4[0] 	= 0;
						cnt5[0] 	= 0;
						cnt6[0] 	= 0;
						cnt7[0] 	= 0;
						cnt8[0] 	= 0;
						cnt9[0] 	= 0;
						cnt10[0] 	= 0;
						cnt11[0] 	= 0;
						cnt12[0] 	= 0;
						cnt13[0] 	= 0;
						cnt14[0] 	= 0;
						cnt15[0] 	= 0;
						cnt16[0] 	= 0;
						cnt17[0] 	= 0;
						cnt18[0] 	= 0;
						cnt19[0] 	= 0;
						cnt20[0] 	= 0;
						
						amt1[0] 	= 0;
						amt2[0] 	= 0;
						amt3[0] 	= 0;
						amt4[0] 	= 0;
						amt5[0] 	= 0;
						amt6[0] 	= 0;
						amt7[0] 	= 0;
						amt8[0] 	= 0;
						amt9[0] 	= 0;
						amt10[0] 	= 0;
						amt11[0] 	= 0;
						amt12[0] 	= 0;
						amt13[0] 	= 0;
						amt14[0] 	= 0;
						amt15[0] 	= 0;
						amt16[0] 	= 0;
						amt17[0] 	= 0;
						amt18[0] 	= 0;
						amt19[0] 	= 0;
						amt20[0] 	= 0;
					
						tot_cnt[0]  = 0;
						tot_amt[0]  = 0;
									 		
						cnt1[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));			
						cnt2[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));			
						cnt3[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));		
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));			
						cnt4[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));			
						cnt5[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));			
						cnt6[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));			
						cnt7[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));			
						cnt8[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));			
						cnt9[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));			
						cnt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));			
						cnt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));			
						cnt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));			
						cnt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));			
						cnt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));			
						cnt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));			
						cnt16[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));			
						cnt17[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));			
						cnt18[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));			
						cnt19[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));			
						cnt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));	
						tot_cnt[0]+= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));			
						
						amt1[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));				
						amt2[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));				
						amt3[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));		
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));				
						amt4[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));				
						amt5[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));				
						amt6[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));				
						amt7[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));				
						amt8[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));				
						amt9[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));				
						amt10[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));		
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));				
						amt11[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));		
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));				
						amt12[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));		
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));				
						amt13[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));		
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));				
						amt14[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));		
						amt15[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));		
						amt16[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));		
						amt17[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));			
						amt18[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));			
						amt19[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));			
						amt20[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));	
						tot_amt[0]+= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));					
																								
		   			}   	 
		   			
		   			cnt1[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT1")));		   		 		
					cnt2[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
					cnt3[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT3")));		
					cnt4[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
					cnt5[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
					cnt6[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT6")));	
					cnt7[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT7")));	
					cnt8[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT8")));	
					cnt9[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT9")));	
					cnt10[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT10")));	
					cnt11[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT11")));	
					cnt12[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT12")));	
					cnt13[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT13")));	
					cnt14[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT14")));	
					cnt15[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT15")));	
					cnt16[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT16")));	
					cnt17[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT17")));	
					cnt18[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT18")));	
					cnt19[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT19")));	
					cnt20[2] 	= AddUtil.parseInt(String.valueOf(ht.get("CNT20")));	
							
						
					amt1[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT1")));
					amt2[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT2")));
					amt3[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT3")));		
					amt4[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
					amt5[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
					amt6[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT6")));	  			
					amt7[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT7")));	  			
					amt8[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT8")));	
				 	amt9[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT9")));	 
					amt10[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT10")));	 
					amt11[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT11")));	 
					amt12[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT12")));	 
					amt13[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT13")));	 		
					amt14[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT14")));	 			
					amt15[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT15")));	 			
					amt16[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT16")));	 			
					amt17[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT17")));	
					amt18[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT18")));	
					amt19[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT19")));	
					amt20[2] 	= AddUtil.parseInt(String.valueOf(ht.get("AMT20")));	
   			%>  
   			   						
                <tr> 
                    <td  align="right"  height="20"><%=Util.parseDecimal(cnt1[2]+cnt2[2]+cnt3[2]+ cnt4[2]+cnt5[2]+cnt6[2]  +cnt7[2]  +cnt8[2]  +cnt9[2]+cnt10[2] +cnt11[2]+cnt12[2]+cnt13[2] +cnt14[2]+cnt15[2]+cnt16[2]+cnt17[2]+cnt18[2]+cnt19[2])%></td>
             	 <td  align="right"  ><%=Util.parseDecimal(amt1[2]+amt2[2]+amt3[2] +amt4[2]+amt5[2]+amt6[2] +amt7[2] +amt8[2] +amt9[2] +amt10[2]+amt11[2]+amt12[2]+amt13[2]+amt14[2]+amt15[2]+amt16[2]+amt17[2]+amt18[2]+amt19[2])%></td>
             			
                    <td  align="right"><%=Util.parseDecimal(cnt1[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt1[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(cnt2[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt2[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(cnt3[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt3[2])%></td>		
                    <td  align="right" ><%=Util.parseDecimal(cnt4[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt4[2])%></td>	
                    <td  align="right" ><%=Util.parseDecimal(cnt5[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt5[2])%></td>	
                    <td  align="right" ><%=Util.parseDecimal(cnt6[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt6[2])%></td>	
                    <td  align="right" ><%=Util.parseDecimal(cnt7[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt7[2])%></td>	
                    <td  align="right" ><%=Util.parseDecimal(cnt8[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt8[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(cnt12[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt12[2])%></td>	
                     <td  align="right"><%=Util.parseDecimal(cnt13[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt13[2])%></td>		
                    <td  align="right"><%=Util.parseDecimal(cnt9[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt9[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt10[2])%></td>
                    <td  align="right" ><%=Util.parseDecimal(amt10[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt11[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt11[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt14[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt14[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt15[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt15[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt16[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt16[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt17[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt17[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt18[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt18[2])%></td>	
                    <td  align="right"><%=Util.parseDecimal(cnt19[2])%></td>
                    <td  align="right"><%=Util.parseDecimal(amt19[2])%></td>	
                																															
                </tr>
        <% } %> 
                <tr> 
                    <td class=title style='text-align:right' height="20" ><%=Util.parseDecimal(tot_cnt[0])%></td>       
                    <td class=title style='text-align:right'><%=Util.parseDecimal(tot_amt[0])%></td>                                      
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt1[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt1[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt2[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt2[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt3[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt3[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt4[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt4[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt5[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt5[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt6[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt6[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt7[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt7[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt8[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt8[0])%></td>	
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt12[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt12[0])%></td>		
                     <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt13[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt13[0])%></td>			
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt9[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt9[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt10[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt10[0])%></td>                   
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt11[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt11[0])%></td>	
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt14[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt14[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt15[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt15[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt16[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt16[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt17[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt17[0])%></td>	
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt18[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt18[0])%></td>		
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(cnt19[0])%></td>
                    <td class=title style='text-align:right' ><%=Util.parseDecimal(amt19[0])%></td>		
                                        
            
                    																																	
                </tr>
               
                <tr>  
                   <td class=title_p  style='text-align:right' height="20"><%=Util.parseDecimal(tot_cnt[1])%></td>                               
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(tot_amt[1])%></td>      
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt1[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt1[1])%></td>     
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt2[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt2[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt3[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt3[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt4[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt4[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt5[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt5[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt6[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt6[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt7[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt7[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt8[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt8[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt12[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt12[1])%></td>
                     <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt13[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt13[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt9[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt9[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt10[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt10[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt11[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt11[1])%></td>	
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt14[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt14[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt15[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt15[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt16[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt16[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt17[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt17[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt18[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt18[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(cnt19[1])%></td>
                    <td class=title_p style='text-align:right' ><%=Util.parseDecimal(amt19[1])%></td>
                  																																	
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>

</body>
</html>
