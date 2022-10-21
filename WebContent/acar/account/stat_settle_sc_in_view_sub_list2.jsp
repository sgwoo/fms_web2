<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.estimate_mng.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	long r_dly_amt = request.getParameter("r_dly_amt")==null?0:Long.parseLong(request.getParameter("r_dly_amt"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = s_db.getStatSettleSubList2Gun(bus_id2);
	int vt_size = vt.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	String var1_3 = e_db.getEstiSikVarCase("1", "", "dly1_bus3");
	String var1_6 = e_db.getEstiSikVarCase("1", "", "dly1_bus6");
	
	//Vector vt2 = s_db.getStatSettleSubHCList2Gun(bus_id2, var1_3, var1_6);
	//int vt_size2 = vt2.size();
	
	
	
	long total_amt 	= 0;
	
%>

<html>
<head>
	<title>Untitled</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">	
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�뿩��޸�
	function view_memo(m_id, l_cd)
	{
		//�ܱ�뿩(����Ʈ)
		if(m_id == '' && l_cd.length ==6){
			var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+l_cd+"&c_id=&user_id=<%=ck_acar_id%>";	
			window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");					
		//���뿩
		}else{
	
			window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
//			window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "FEE_MEMO", "left=0, top=0, width=850, height=750, scrollbars=yes");
		}

	}	
	//������� ����
	function view_client(m_id, l_cd)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	function view_scd(m_id, l_cd){
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_SCD", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	//��ü�� ���·� û������
	function view_fine_doc(client_id){
		window.open("fine_reqdoc_select.jsp?client_id="+client_id+"&bus_id2=<%=bus_id2%>", "VIEW_FINE_DOC", "left=100, top=100, width=950, height=600, scrollbars=yes");	
	}
//-->	
</script>		
</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value=''>
<input type='hidden' name='br_id' value=''>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='size' value='8'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5><%=c_db.getNameById(bus_id2,"USER")%> ä�Ǹ���Ʈ </span></span></td>
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
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=3% class='title'>����</td>
                    <td width=10% class='title'>����ȣ</td>
                    <td width=15% class='title'>��ȣ</td>
                    <td width=8% class='title'>������ȣ</td>
                    <td width=11% class='title'>����</td>					
                    <td width=7% class='title'>�׸�</td>
                    <td width=12% class='title'>����</td>
                    <td width=8% class='title'>�Աݿ�����</td>
                    <td width=7% class='title'>��ü�ݾ�</td>
					<td width=4% class='title'>��ȭ</td>
					<td width=8% class='title'>���ξ����</td>
					<td width=7% class='title'>CMS</td>
                </tr>		
<%
	//�뿩�Ḯ��Ʈ
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>				  
                <tr> 
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=i+1%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title=""><%=ht.get("RENT_L_CD")%></a></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("FIRM_NM")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("CAR_NO")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("CAR_NM")%></td>					
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>>
					<%if(String.valueOf(ht.get("GUBUN1")).equals("�뿩��")||String.valueOf(ht.get("GUBUN1")).equals("��ü����")){%>
					<a href="javascript:view_scd('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("GUBUN1")%></a>
					<%}else if(String.valueOf(ht.get("GUBUN1")).equals("���·�")){%>
					<a href="javascript:view_fine_doc('<%=ht.get("CLIENT_ID")%>')"><%=ht.get("GUBUN1")%></a>
					<%}else{%>
					<%=ht.get("GUBUN1")%>
					<%}%>
					</td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("GUBUN2")%><br><%=ht.get("USER_NM")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>					
                    <td align="right"  <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>
                        <%if(String.valueOf(ht.get("GUBUN2")).equals("����Ʈ") && !String.valueOf(ht.get("DLY_AMT")).equals(String.valueOf(ht.get("DLY_AMT2")))){%>
                            <br>(<%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT2")))%>)
                        <%}%>
                    </td>		
					<td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><a href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title="">����</a></td>
					<td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROMISE_DT")))%></td>
					<td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("CMS_BANK")%>
					<!--
					<a href="/fms2/con_fee/acms_list.jsp?acode=<%=ht.get("RENT_L_CD")%>" target="_blank"><%=ht.get("CMS_BANK")%></a>
					<%	if(!String.valueOf(ht.get("CMS_BANK")).equals("") && !String.valueOf(ht.get("CBIT")).equals("����")){%>
					<br><%=ht.get("CBIT")%>
					<%		if(String.valueOf(ht.get("CBIT")).equals("�����Ϸ�")){%>
					<br>(<%=ht.get("LDATE")%>)
					<%		}%>
					<%	}%>
					-->
					</td>								
                </tr>
<%			total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
		%>		
                <tr> 
                    <td class="title" colspan="8" >�հ� </td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
                </tr>		
<%	} %>		 
            </table>
        </td>
    </tr>
    <tr>
        <td>�� ķ���� �ݿ��ݾ� <%=Util.parseDecimal(r_dly_amt)%> =  ä���հ� <%=Util.parseDecimal(total_amt)%> - �����ݾ� <%=Util.parseDecimal(total_amt-r_dly_amt)%></td>
    </tr>	
    <tr>
        <td>�� �����ݾ� : �뿩�� - ȸ�������� 10% �ݿ�<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���·� - 5�� ����, ��å�� - 100%<br>			
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��������� - ��������û���� �氨, 100�������� 100%, 100�����ʰ��� 100����+�ʰ�20% �ݿ�, 3����
		</td>
    </tr>	
</table>
</form>
</body>
</html>
