<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String com_code 	= request.getParameter("com_code")==null?"":request.getParameter("com_code");
	String com_name 	= request.getParameter("com_name")==null?"":request.getParameter("com_name");
	
	
	String  acct_code_yn[]   = new String[13];
	for(int i=0; i<13; i++){
		acct_code_yn[i] = "N";
	}
	int count = 0;
	String acct_code = "";
	String acct_code_nm = "";
	
	end_dt = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
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

	//ī�峻�뺸��
	function CardUseList(acct_code_nm, acct_code){
		var fm = document.form1;
		fm.acct_code_nm.value = acct_code_nm;
		fm.acct_code.value = acct_code;
		fm.action = "card_use_com_d_sc_list.jsp";
		fm.target = "inner_in";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='com_code' value='<%=com_code%>'>
<input type='hidden' name='com_name' value='<%=com_name%>'>
<input type='hidden' name='acct_code' value='<%=acct_code%>'>
<input type='hidden' name='acct_code_nm' value='<%=acct_code_nm%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>	
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=com_name%></span></td>
    </tr>	
<%	Vector vts2 = CardDb.getCardUseAcctStat2(com_code, s_br, "3", chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, "", s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();%>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>      	
                <tr>
                  <td width='10%' rowspan="2" class='title'>��������</td>
                  <td colspan="2" class='title'>�հ�</td>
                  <td colspan="2" class='title'>������</td>
                  <td colspan="2" class='title'>������</td>
                  <td colspan="2" class='title'>�ѹ���</td>
                  <td colspan="2" class='title'>�ӿ�</td>
                </tr>
                <tr>
                  <td width='8%' class='title'>�Ǽ�</td>
                  <td width='10%' class='title'>�ݾ�</td>
                  <td width='8%' class='title'>�Ǽ�</td>
                  <td width='10%' class='title'>�ݾ�</td>
                  <td width='8%' class='title'>�Ǽ�</td>
                  <td width='10%' class='title'>�ݾ�</td>
                  <td width='8%' class='title'>�Ǽ�</td>
                  <td width='10%' class='title'>�ݾ�</td>
                  <td width='8%' class='title'>�Ǽ�</td>
                  <td width='10%' class='title'>�ݾ�</td>
                </tr>
                <%	int  cnt2[]   = new int[5];
        		  	long amt2[]   = new long[5];
        			int  t_cnt2[] = new int[5];
        		  	long t_amt2[] = new long[5];
        			if(vt_size2 > 0){%>
                <%	for(int i = 0 ; i < vt_size2 ; i++){
        					Hashtable ht = (Hashtable)vts2.elementAt(i);
        					for(int j=0; j<5; j++){
        						cnt2[j]  = AddUtil.parseInt(String.valueOf(ht.get("CNT"+j)));
        						amt2[j]  = AddUtil.parseLong(String.valueOf(ht.get("AMT"+j)));
        					}
        					for(int j=0; j<5; j++){
        						t_cnt2[j] += cnt2[j];
        						t_amt2[j] += amt2[j];
        					}
        					
        					if(i==0){
        						acct_code = String.valueOf(ht.get("ACCT_CODE"));
        						acct_code_nm = String.valueOf(ht.get("ACCT_CODE_NM"));
        					}
        					%>
                <tr>
                  <td align="center"><a href="javascript:CardUseList('<%=ht.get("ACCT_CODE_NM")%>','<%=ht.get("ACCT_CODE")%>')"><%=ht.get("ACCT_CODE_NM")%></a></td>
                  <td align="right"><%=cnt2[0]%>��</td>
                  <td align="right"><%=Util.parseDecimal(amt2[0])%>��</td>
                  <td align="right"><%=cnt2[1]%>��</td>
                  <td align="right"><%=Util.parseDecimal(amt2[1])%>��</td>
                  <td align="right"><%=cnt2[2]%>��</td>
                  <td align="right"><%=Util.parseDecimal(amt2[2])%>��</td>
                  <td align="right"><%=cnt2[3]%>��</td>
                  <td align="right"><%=Util.parseDecimal(amt2[3])%>��</td>
                  <td align="right"><%=cnt2[4]%>��</td>
                  <td align="right"><%=Util.parseDecimal(amt2[4])%>��</td>
                </tr>
                <%	}%>
                <tr>
                  <td align="center" class=title>�հ�</td>
                  <%for(int j=0; j<5; j++){%>
                  <td style="text-align:right" class="title"><%=t_cnt2[j]%>��</td>
                  <td style="text-align:right" class="title"><%=Util.parseDecimal(t_amt2[j])%>��</td>
                  <%}%>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>		
	<%	if(vt_size2 > 0){
		int height =440-(vt_size2*25);
	%>
    <tr> 
      <td></td>
    </tr>		
    <tr> 
      <td height="<%=height%>" colspan="2"><iframe src="card_use_com_d_sc_list.jsp<%=hidden_value%>&com_code=<%=com_code%>&com_name=<%=com_name%>&acct_code=<%=acct_code%>&acct_code_nm=<%=acct_code_nm%>" name="inner_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--����ͳ��� - sh ���� - ��ܸ޴� ���� - (���μ�*40)-->
    </tr>
	<%}%>
  </table>
</form>
</body>
</html>
