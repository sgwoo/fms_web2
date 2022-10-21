<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String est_dt 	= request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
	
	Vector vt = ae_db.getScdPpCostAccountStat(est_dt, gubun2);
	int vt_size = vt.size();	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='est_dt' value=''>
<input type='hidden' name='gubun' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수익반영금액</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='25%'  class='title'>기준일자</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(est_dt)%>
            &nbsp;&nbsp;
            <%if(gubun2.equals("1")){%> (선납금) <%}%>
            <%if(gubun2.equals("2")){%> (개시대여료) <%}%>
            <%if(gubun2.equals("3")){%> (대여료) <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr> 	
    <tr> 
        <td class=h></td>
    </tr>      
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='25%' class='title'>구분</td>
                    <td width='25%' class='title'>수익반영</td>
                    <td width='25%' class='title'>환불(해지)</td>
                    <td width='25%' class='title'>합계</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
								//total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
					      %>    
				<tr>
                    <td align="center"><%=ht.get("CAR_USE")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
                    <td align="right">미반영<%//=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
                    <td align="right">-<%//=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT2")))+AddUtil.parseLong(String.valueOf(ht.get("AMT3"))))%></td>                    
                </tr>	
                <%			}%>	      
				<tr>
                    <td align="center">합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%//=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%//=AddUtil.parseDecimalLong(total_amt2+total_amt3)%></td>                    
                </tr>	
                <%	}%>
            </table>
	    </td>
    </tr> 	
    <tr> 
        <td class=h></td>
    </tr>         <tr>
      <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>      
  </table>
</form>
</body>
</html>