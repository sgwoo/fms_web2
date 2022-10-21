<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function view_scd(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.target = 'd_content';
		fm.action='fee_c_mgr.jsp'
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String acode = request.getParameter("acode")==null?"":request.getParameter("acode");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	//acms 테이블에서 입금미반영 리스트 조회하기
	Vector vt = af_db.getACmsDateContList(acode);
	int vt_size = vt.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='acode' value='<%=acode%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='sh_height' value='74'>
<table border="0" cellspacing="0" cellpadding="0" width=700>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>자동이체조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
        		    <td width='40' class='title'>연번</td>
        		    <td width='120' class='title'>은행</td>
        		    <td width='210' class='title'>계좌번호</td>		  
        		    <td width='110' class='title'>출금일자</td>
        		    <td width='110' class='title'>출금의뢰금액</td>
        		    <td width='110' class='title'>출금액</td>
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr>
		            <td align="center" ><%=i+1%></td>
        		    <td align="center" >&nbsp;<%=ht.get("NM")%></td>
        		    <td align="center" ><%=ht.get("ABNO")%></td>
        		    <td align="center" ><%=ht.get("ADATE")%></td>		  
        		    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AAMT")))%>&nbsp;</td>
        		    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AOUTAMT")))%>&nbsp;</td>
		        </tr>
<%			total_amt1 = total_amt1 + Long.parseLong(String.valueOf(ht.get("AAMT")));
			total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("AOUTAMT")));
		}%>	
		        <tr>
        		    <td class=title>&nbsp;</td>
        		    <td class=title>합계</td>
        		    <td class=title>&nbsp;</td>
        		    <td class=title>&nbsp;</td>
        		    <td style='text-align:right' class=title><%=Util.parseDecimal(total_amt1)%>&nbsp;</td>
        		    <td style='text-align:right' class=title><%=Util.parseDecimal(total_amt2)%>&nbsp;</td>
		        </tr>	
	        </table>
	    </td>
    </tr> 
    <tr>
        <td align=right><a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif border=0></a></td> 
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>