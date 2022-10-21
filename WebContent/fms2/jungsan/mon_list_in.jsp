<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm	= request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String s_mon	= request.getParameter("s_mon")==null?"2":request.getParameter("s_mon");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	String st_mon		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	int year =AddUtil.getDate2(1);
	
	int kk =0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

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
	
			
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr><td class=line2 colspan="2"></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='23%' id='td_title' style='position:relative;'> 
<%	
	int vt_size2 = 0;
	Vector vts2 = JsDb.getCardJungDtStatINew_mon(dt, st_year, st_mon, ref_dt1, ref_dt2, br_id, dept_id, user_nm);
  	 
	vt_size2 = vts2.size();
	
	%>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>

          <tr> 
            <td width="15%"  class="title" style='height:78'>연번</td>
            <td width="29%" class="title">부서</td>
            <td width="26%" class="title">직급</td>
            <td width="30%" class="title">성명</td>
          </tr>
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >

         <tr>
            <td colspan="5"  class="title">설정금액</td>
            <td colspan="4"  class="title">지출금액</td>          
            <td width="10%" rowspan="3"  class="title" ><p>정산<br>
          
            </p>
            </td>
          </tr>
         <tr>
           <td width="10%" rowspan=2 class="title">중식대</td>
           <td colspan=2 class="title">복리후생</td>
           <td width="10%" rowspan=2 class="title">팀장활동비</td>
           <td width="10%" rowspan=2 class="title" >소계(A)</td>
           <td width="10%" rowspan=2 class="title" >식대</td>
           <td width="10%" rowspan=2 class="title" >복리후생</td>
           <td width="10%" rowspan=2 class="title" >팀장활동비</td>
           <td width="10%" rowspan=2 class="title" >소계(B)</td>
         </tr>
          <tr>
           <td width="10%"  class="title">회식비</td>
           <td width="10%"  class="title">특별(근속,방역)</td>         
         </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='23%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	
        	long gt_amt[] = new long[10];  //grand total
        	long st1_amt[] = new long[10];  //sub total
        	long st2_amt[] = new long[10];  //sub total
        	long amt[] = new long[10];  //
        	
        	long a_tot = 0; //잔액	
        	long ta_tot = 0; //total 정산 
        	String nn= "";
        %>
        
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if (ht.get("USER_ID").equals("000177")) continue;
					
           			 nn =(String) ht.get("DEPT_NM");
            
           			 kk += 1; 
         %>			
          <tr> 
          	<td width="15%" align="center"><%= kk %></td>
          	<td width="29%" align="center"><%=nn%></td>
            <td width="26%" align="center"><%=ht.get("USER_POS")%></td>
            <td width="30%" align="center"><%=ht.get("USER_NM")%>
            <%if( String.valueOf(ht.get("USER_ID")).equals(ck_acar_id) ) {%>
            <a href="javascript:MM_openBrWindow('/card/card_jung/card_jung_sc_in.jsp?work_nm=<%=ht.get("USER_NM")%>&work=<%=ht.get("W_CNT")%>&st_year=<%=st_year%>&st_mon=<%=AddUtil.addZero(st_mon)%>&auth_rw=1&user_id=<%= ht.get("USER_ID") %>&br_id=<%= ht.get("BR_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=860,height=700,top=20,left=20')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
              <% } %>  
            </td>
            
          </tr>
          <%}%>
          <tr> 
            <td class=title colspan="4" align="center">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%
          		
          for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					if (ht.get("USER_ID").equals("000177")) continue;
					
					for (int j = 1 ; j <= 8 ; j++){
						
						amt[j] = AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));   //  total
						
						gt_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  //grand total
																				
					}
					
					//팀장이상은 회식비+기타 비용 정산	 
					if(ht.get("USER_ID").equals("000003")||ht.get("USER_ID").equals("000004")||ht.get("USER_ID").equals("000005")||ht.get("USER_ID").equals("000026")  ||ht.get("USER_ID").equals("000028")   ||ht.get("USER_ID").equals("000237") ){
						a_tot = amt[4]+amt[5] -amt[2]; 
						
					}else{
						a_tot = amt[8]+amt[4]+amt[5]+amt[6] -amt[1] -amt[2]-amt[3]; 
					}
					
					ta_tot += a_tot;						 										
		%>
          <tr> 
         	<td width='10%' align="right"><%=Util.parseDecimal(amt[8])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[4])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[5])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[6])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[8]+amt[4]+amt[5]+amt[6])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[1])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[2])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[3])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(amt[1]+amt[2]+amt[3])%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(a_tot)%></td>
          </tr>
    <%}%>
          <tr> 

            <td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[8])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[4])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[5])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[6])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[8]+gt_amt[4]+gt_amt[5]+gt_amt[6])%></div></td> <!-- 소계 -->
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[1])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[2])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[3])%></div></td>
			<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[1]+gt_amt[2]+gt_amt[3])%></div></td> 	<!-- 소계 -->		
			<td class='title' ><div align="right"><%=Util.parseDecimal(ta_tot)%></div></td>
          </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='23%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
