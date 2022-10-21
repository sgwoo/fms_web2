<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*, acar.estimate_mng.*" %>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String brch 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String loan_st 	= request.getParameter("loan_st")	==null?"":request.getParameter("loan_st");
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");	
	String max_amt 	= request.getParameter("max_amt")	==null?"":request.getParameter("max_amt");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String var6 	= e_db.getEstiSikVarCase("1", "", "dly1_bus6");
	
	
	//ä��ķ���� ��»󸮽�Ʈ
	Vector vt = st_db.getStatSettleEff(loan_st, var6, save_dt, max_amt);
	int vt_size = vt.size();	

	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form action="" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="550">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > ä��ķ���� > <span class=style5>ä��ķ���� <%=loan_st%>�� ��»�</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="550">
                <tr> 
                    <td width="200" class=title>�����</td>                    
                    <!--
                    <td width="100" class=title>��տ�ü��</td>
                    <td width="100" class=title>���Ͽ�ü��</td>                    
                    -->
                    <td width="200" class=title>���б��񰨼�ġ���</td>
                    <td width="100" class=title>���</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align='center'><%=ht.get("USER_NM")%></td>                    
                    <!--
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("AVG_PER")),3)%></td>
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER1")),3)%></td>
                    -->
                    <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("EFF_PER")),3)%></td>
                    <td align='center'><%if(i<3){%><%=i+1%>����<%}%></td>
                </tr>    			
	  	<%}%>

            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a></td>
    </tr>	
    <tr>    	
        <td>* 1���� : ����� - ���������� 100%<!--<%if(loan_st.equals("1")){%>, ��Ʈ�� - 80%<%}%>--></td>
    </tr>    	
    <tr>    	
        <td>* 2���� : ����� - ���������� 90%<!--<%if(loan_st.equals("1")){%>, ��Ʈ�� - 70%<%}%>--></td>
    </tr>	
    <tr>    	
        <td>* 3���� : ����� - ���������� 80%<!--<%if(loan_st.equals("1")){%>, ��Ʈ�� - 60%<%}%>--></td>
    </tr>	    
     <tr>    	
        <td>* ���б⸶�� ��ü�� ��� ���Ͽ�ü�� ����ġ�� ķ���αⰣ���� ��ռ�</td>
    </tr>	 
    

</table>
</form>
</body>
</html>
