<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*,acar.client.*"%>
<%@ page import="acar.res_search.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	
	
	if(client_id.equals("") || client_id.equals("null")) return;
	
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "01", "07", "12");
	
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//���� ������ ����Ʈ
	Vector vt = af_db.getClientContScdList(client_id);
	int vt_size = vt.size();	
	
	int tm_st2_4_yn = 0;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function save(){
		var fm = document.form1;
		
		if(fm.use_s_dt.value == '')		{ alert('���Ⱓ�� �Է��Ͻʽÿ�.'); return; }
		if(fm.use_e_dt.value == '')		{ alert('���Ⱓ�� �Է��Ͻʽÿ�.'); return; }
		if(fm.fee_est_dt.value == '')	{ alert('�Աݿ������� �Է��Ͻʽÿ�.'); return; }
		if(fm.req_dt.value == '')			{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }
		if(fm.tax_out_dt.value == '')	{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }
		
		if(fm.tm_st2_4_cnt.value != 0){
			if(fm.req_dt2.value == '')			{ alert('�����ݱյ���ེ���� �������ڸ� �Է��Ͻʽÿ�.'); return; }
			if(fm.tax_out_dt2.value == '')	{ alert('�����ݱյ���ེ���� �������ڸ� �Է��Ͻʽÿ�.'); return; }
		}
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='fee_all_cng_c_a.jsp';
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}
	}
	
	function ViewScdFeeList(m_id, l_cd, rent_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.rent_st.value = rent_st;
		fm.action = "fee_scd_u_sc.jsp";
		window.open("about:blank", "ViewScdFeeList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
		fm.target = "ViewScdFeeList";
		fm.submit();		
	}	
	
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='fee_all_cng_c_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name="client_id" 	value="<%=client_id%>">
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="from_page" 	value="/fms2/con_fee/fee_all_cng_c.jsp">
  <input type='hidden' name="m_id" 	value="">
  <input type='hidden' name="l_cd" 	value="">
  <input type='hidden' name="rent_st" 	value="">
  <input type='hidden' name="mode" 	value="view">
  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>��ȣ</td>
                    <td width=37%>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                    <td class=title width=10%>��ǥ��</td>
                    <td width=40%>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>    
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">����ȣ</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">������ȣ</td>
                    <td style="font-size : 8pt;" width="12%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">ȸ��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���Ⱓ</td>
                    <td style="font-size : 8pt;" class=title colspan="3">���뿩��</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�Աݿ�����</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�ŷ�ó������</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">��������</td>
                    <td style="font-size : 8pt;" width="2%" class=title rowspan="2">������</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="8%" class=title>������</td>
                    <td style="font-size : 8pt;" width="8%" class=title>������</td>
                    <td style="font-size : 8pt;" width="7%" class=title>���ް�</td>
                    <td style="font-size : 8pt;" width="5%" class=title>�ΰ���</td>
                    <td style="font-size : 8pt;" width="8%" class=title>�հ�</td>
                </tr>
                <%for(int i=0; i<vt_size; i++){
                		Hashtable ht = (Hashtable)vt.elementAt(i);
                		
                		if(String.valueOf(ht.get("TM_ST2")).equals("4")){
                			tm_st2_4_yn++;
                		}
                		
                %>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><input type="checkbox" name="ch_l_cd" value="<%=ht.get("RENT_MNG_ID")%>|<%=ht.get("RENT_L_CD")%>|<%=ht.get("RENT_ST")%>|<%=ht.get("RENT_SEQ")%>|<%=ht.get("FEE_TM")%>|<%=ht.get("TM_ST2")%>|<%=ht.get("T_USE_S_DT")%>|<%=ht.get("T_USE_E_DT")%>|<%=ht.get("T_FEE_S_AMT")%>|<%=ht.get("T_FEE_V_AMT")%>" checked></td>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("RENT_L_CD")%></td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("CAR_NO")%></td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("CAR_NM")%></td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("FEE_TM")%><%if(String.valueOf(ht.get("TM_ST2")).equals("4")){%><font color=red>(��)</font>
                    	<%}%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td style="font-size : 8pt;" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
                    <td style="font-size : 8pt;" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%></td>
                    <td style="font-size : 8pt;" align="right"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT"))))%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td style="font-size : 8pt;" align="center"><a href="javascript:ViewScdFeeList('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title="����Ʈ ����"><img src="/images/esti_detail.gif" align=absmiddle border="0"></a></td>
                </tr>
                <%}%>
            </table>
	    </td>
	</tr>		
	<tr>
	    <td align="right">&nbsp;�� ���뿩�� �ݾ��� ������ �ʰ�, ���Ⱓ�� ���� ���ڰ���� �˴ϴ�. ȸ���� ������ (��)�� �����ݱյ���� �������Դϴ�.</td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>ȸ������</td>
                    <td width=37%>&nbsp;����Ʈ ȸ������ ������ȸ�� ���� ����</td>
                    <td class=title width=10%>ȸ������</td>
                    <td>&nbsp;1����</td>
                </tr>
                <tr>
                    <td class=title>���Ⱓ</td>
                    <td>&nbsp;<input type='text' name='use_s_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    	~
                    	<input type='text' name='use_e_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td class=title>�Աݿ�����</td>
                    <td>&nbsp;<input type='text' name='fee_est_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' name='req_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' name='tax_out_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr>
                    <td class='title'>��������1</td>
                    <td colspan='3'>
                        &nbsp;<input type="checkbox" name="maxday_yn1" value="Y"> ����
                        <font color=red>&nbsp;(���Ⱓ ������-�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                                
                <tr>
                    <td class='title'>��������2</td>
                    <td colspan='3'>
                        &nbsp;<input type="checkbox" name="maxday_yn2" value="Y"> ����
                        <font color=red>&nbsp;(�Աݿ�����-�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                                
                <tr>
                    <td class='title'>��������3</td>
                    <td colspan='3'>
                        &nbsp;<input type="checkbox" name="maxday_yn3" value="Y"> ����
                        <font color=red>&nbsp;(��������-�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                
                <tr>
                    <td class='title'>�����Ϻ���</td>
                    <td colspan='3'>
                        &nbsp;<input type="checkbox" name="fee_est_day_cng" value="Y"> ������-�뿩������ �ſ��������ڵ� ����
                    </td>
                </tr>		                                
            </table>
	    </td>
    </tr>
    <%if(tm_st2_4_yn>0){%>
	<tr>
	    <td>&nbsp;<input type="checkbox" name="tm_st2_4_yn" value="Y"> �����ݱյ���ེ���ٵ� �ϰ� ó���Ѵ�.</td>
	</tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>ȸ������</td>
                    <td width=37%>&nbsp;����Ʈ ȸ������ ������ȸ�� ���� ����</td>
                    <td class=title width=10%>ȸ������</td>
                    <td>&nbsp;1����</td>
                </tr>
                <tr>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' name='req_dt2' value='' size='10' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' name='tax_out_dt2' value='' size='10' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr>
                    <td class='title'>��������3</td>
                    <td colspan='3'>
                        &nbsp;<input type="checkbox" name="maxday_yn4" value="Y"> ����
                        <font color=red>&nbsp;(��������-�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                
            </table>
	    </td>
    </tr>	
    <%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>    	

    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
</table>
<input type='hidden' name='tm_st2_4_cnt' 	value='<%=tm_st2_4_yn%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
