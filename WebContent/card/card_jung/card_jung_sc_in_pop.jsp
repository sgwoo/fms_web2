<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
    String s_user 		=  request.getParameter("s_user")==null?"":request.getParameter("s_user");
    String s_work 		=  request.getParameter("s_work")==null?"":request.getParameter("s_work");
    String s_work_nm 	=  request.getParameter("s_work_nm")==null?"":request.getParameter("s_work_nm");
	String s_buy_dt 	=  request.getParameter("s_buy_dt")==null?"":request.getParameter("s_buy_dt");
    
   	String dt			= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String st_year 		= request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon 		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String s_yy 		= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
 <input type='hidden' name='s_user' 	value='<%=s_user%>'>       
 <input type='hidden' name='s_work' 	value='<%=s_work%>'>       
 <input type='hidden' name='s_work_nm' 	value='<%=s_work_nm%>'>       
 <input type='hidden' name='dt' 		value='<%=dt%>'>       
 <input type='hidden' name='ref_dt1' 	value='<%=ref_dt1%>'>       
 <input type='hidden' name='ref_dt2' 	value='<%=ref_dt2%>'>          
 <input type='hidden' name='st_year' 	value='<%=st_year%>'>       
 <input type='hidden' name='st_mon' 	value='<%=st_mon%>'>          
 <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>           
 <input type='hidden' name='s_buy_dt'	value='<%=s_buy_dt%>'>            
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
  	    <td align='left'>&nbsp;&nbsp; <% if( !s_work.equals("A")){%> <img src=/acar/images/center/arrow_sm.gif> : <%=s_work_nm%> &nbsp; &nbsp; <%=s_buy_dt%> <%}%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
  <tr>
	  <td colspan=2> 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>회식비내역</span></td>
          </tr>
        </table></td>
	
  </tr>
  <tr>
    <td class=line2 colspan=2></td>
  </tr>
  <tr>
  	   <td colspan=2 class='line' width='100%'> 
<%	String acct_code ="00001";//복리후생비
	String acct_code_g = "2";//복지비
	
	Vector vts3 = CardDb.getCardJungDtStatG4NewSubList(s_buy_dt, s_user, acct_code, acct_code_g);
	int vt_size3 = vts3.size();
%>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    
              <tr> 
                <td width='5%' class='title'>연번</td>
                <td width='15%' class='title'>카드번호</td>
                <td width='15%' class='title'>거래처</td>
                <td width='10%' class='title'>전표금액</td>
                <td width='21%' class='title'>적요</td>								
                <td width='7%' class='title'>사용자</td>
                <td width='10%' class='title'>사용자금액</td>				
                <td width='7%' class='title'>등록자</td>
                <td width='10%' class='title'>등록일자</td>
              </tr>
<%	if(vt_size3 > 0){
		long t_b_amt = 0;; //복지비%>
            <%	for(int j = 0 ; j < vt_size3; j++){
   					Hashtable ht = (Hashtable)vts3.elementAt(j);
					t_b_amt += AddUtil.parseLong(String.valueOf(ht.get("DOC_AMT")));
   			%>
              <tr> 
              	 <td align="center"><%= j+1%></td>
                 <td align="center"><%=ht.get("CARDNO")%></td>
                 <td align="center"><%=ht.get("VEN_NAME")%></td>				 
                 <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%>원</td>
                 <td align="center"><%=ht.get("ACCT_CONT")%></td>
                 <td align="center"><%=ht.get("USER_NM")%></td>
                 <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DOC_AMT")))%>원</td>
                 <td align="center"><%=ht.get("REG_NM")%></td>
                 <td align="center"><%=ht.get("REG_DT")%></td>
              </tr>
              <%}%>
              <tr> 
                <td class=title align="center" colspan=6>합계</td>
                <td class=title style="text-align:right">&nbsp;<%=Util.parseDecimal(t_b_amt)%>원</td>
                <td class=title align="center" colspan=2></td>				
              </tr>		
<% 	}%>      
              </table></td>
     </tr>    
  </table>
</form>
</body>
</html>
