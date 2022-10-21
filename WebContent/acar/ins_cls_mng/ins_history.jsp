<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//���������ȣ
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = "5";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
		
	
	int total_amt1 = 0;
	int total_amt2 = 0;	
	
	if(!c_id.equals("") && m_id.equals("") && l_cd.equals("")){
		RentListBean bean = ai_db.getLongRentCase(c_id);
		m_id = bean.getRent_mng_id();
		l_cd = bean.getRent_l_cd();
	}	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�ٸ� �������� ����
	function move_ins(ins_st){	
		var fm = document.form1;	
		fm.mode.value = '';
		fm.ins_st.value = ins_st;
		fm.action = "ins_u_frame.jsp";		
		fm.target = "d_content";
		fm.submit();
	}
	
	//����
	function move_reg(){	
		var fm = document.form1;	
		fm.action = "../ins_reg/ins_reg_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}	
	//����
	function move_cls(ins_st){	
		var fm = document.form1;
		fm.ins_st.value = ins_st;	
		fm.action = "../ins_cls/ins_cls_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
  <form action="ins_u_frame.jsp" name="form1">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='ins_st' value='<%=ins_st%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value=''>	
  </form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=13%><%=l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=21%><%=cont.get("FIRM_NM")%></td>
                    <td class=title width=10%>�����</td>
                    <td width=12%><%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>��뺻����</td>
                    <td width=14%><%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td><%=cont.get("CAR_NO")%></td>
                    <td class=title>����</td>
                    <td><%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>���ʵ����</td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>�����ȣ</td>
                    <td><%=cont.get("CAR_NUM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� �̷� ����Ʈ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width=6%>����</td>
                  <td class=title width="9%">����</td>
                  <td class=title width="15%%">����ȣ</td>
                  <td class=title width="20%">��ȣ</td>
                  <td class=title width="20%">�뿩�Ⱓ</td>
                  <td class=title width="10%">�뿩����</td>
                  <td class=title width="10%">�뿩���</td>
                  <td class=title width="10%">��������</td>
                </tr>
                <%//����̷�
        			Vector rents = ai_db.getRentHisList(c_id);
        			int rent_size = rents.size();
        			if(rent_size > 0){		
        				for(int i = 0 ; i < rent_size ; i++){
        				Hashtable rent = (Hashtable)rents.elementAt(i);%>
                <tr> 
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=rent.get("USE_YN")%>
        		  <%if(!String.valueOf(rent.get("CLS_ST")).equals("")){%>
        		  (<%=rent.get("CLS_ST")%>)
        		  <%}%></td>
                  <td align="center"><%=rent.get("RENT_L_CD")%></td>
                  <td align="center"><%=rent.get("FIRM_NM")%></td>
                  <td align="center"><%=rent.get("RENT_START_DT")%>~<%=rent.get("RENT_END_DT")%></td>
                  <td align="center"><%=rent.get("CAR_ST")%></td>
                  <td align="center"><%=rent.get("RENT_WAY")%></td>
                  <td align="center"><%=rent.get("CLS_DT")%></td>
                </tr>
                <%		}%>
                <%	}%>
                <%	sBean = olsD.getSui(c_id);
        			if(!sBean.getMigr_dt().equals("")){%>
                <tr> 
                  <td class=title>����</td>
                  <td class=title>����</td>
                  <td class=title>-</td>
                  <td class=title>�����</td>
                  <td class=title>����ó</td>
                  <td class=title>�������</td>
                  <td class=title>�ŸŴ��</td>
                  <td class=title>����������</td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">��������</td>
                  <td align="center">-</td>
                  <td align="center"><%=sBean.getSui_nm()%></td>
                  <td align="center"><%=sBean.getH_tel()%>,<%=sBean.getM_tel()%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
                  <td align="center"><%=AddUtil.parseDecimal(sBean.getMm_pr())%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <%		//�뵵���� �̷�
			Vector cngs = ai_db.getCarNoCng(c_id);
			int cng_size = cngs.size();
			if(cng_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뵵���� ����Ʈ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <%     		for(int i = 0 ; i < cng_size ; i++){
        					Hashtable cng = (Hashtable)cngs.elementAt(i);
        					String cha_cau = String.valueOf(cng.get("CHA_CAU"));%>
                <tr> 
                  <td class=title width=10%>��������</td>
                  <td width=13%><%=AddUtil.ChangeDate2(String.valueOf(cng.get("CHA_DT")))%></td>
                  <td class=title width=10%>�������</td>
                  <td width=21%> 
                    <%if(cha_cau.equals("1")){%>
                    ��뺻���� ���� 
                    <%}else if(cha_cau.equals("2")){%>
                    �뵵���� 
                    <%}else if(cha_cau.equals("3")){%>
                    ��Ÿ 
                    <%}else if(cha_cau.equals("4")){%>
                    ���� 
                    <%}else if(cha_cau.equals("5")){%>
                    �űԵ�� 
                    <%}%>
                  </td>
                  <td class=title width=10%>���泻��</td>
                  <td width=36%><%=cng.get("CHA_CAU_SUB")%> </td>
                </tr>
                <%			}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
  <%	}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �̷� ����Ʈ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="6%">����</td>
                  <td class=title width="8%">����</td>
                  <td class=title width="8%">��������</td>
                  <td class=title width="8%">������</td>
                  <td class=title width="20%">����Ⱓ</td>
                  <td class=title width="13%">�����</td>
                  <td class=title width="13%">ȯ�ޱݾ�</td>
                  <td class=title width="16%">���/��������</td>
                  <td class=title width="8%">����</td>
                </tr>
                <%//�����̷�-�Ϲݺ���
        			Vector inss2 = ai_db.getInsHisList1(c_id);
        			int ins_size2 = inss2.size();
        			if(ins_size2 > 0){
                		for(int i = 0 ; i < ins_size2 ; i++){
        				Hashtable ins2 = (Hashtable)inss2.elementAt(i);%>
                <tr> 
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=ins2.get("INS_STS")%></td>
                  <td align="center"><%=ins2.get("GUBUN")%></td>
                  <td align="center"><%=ins2.get("INS_COM_NM")%></td>
                  <td align="center"><%=ins2.get("INS_START_DT")%>~<%=ins2.get("INS_EXP_DT")%></td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(ins2.get("INS_AMT")))%>��&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(ins2.get("RTN_AMT")))%>��&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td>&nbsp;<%=ins2.get("REG_CAU")%>&nbsp;<%=ins2.get("EXP_CAU")%></td>
                  <td align="center"><a href="javascript:move_cls('<%=ins2.get("INS_ST")%>')"><img src="/acar/images/center/button_in_hj.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}%>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>