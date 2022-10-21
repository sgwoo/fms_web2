<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.car_service.*, acar.cus_reg.*, acar.serv_off.*, acar.user_mng.*"%>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="p_bean" class="acar.accid.PicAccidBean" scope="page"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	if(m_id.equals("")){
		m_id = a_bean.getRent_mng_id();
		l_cd = a_bean.getRent_l_cd();
	}
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//��������
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	

	//����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList2(c_id, accid_id);

	PicAccidBean pa_r [] = as_db.getPicAccidList(c_id, accid_id);
	int size = pa_r.length;
	int s_idx=0;
	int e_idx=0;
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(!car_st.equals("") && car_st.length() >=5)	car_st = car_st.substring(4,5);
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("") && accid_dt.length() >=12){
		accid_dt 	= a_bean.getAccid_dt().substring(0,8);
		accid_dt_h 	= a_bean.getAccid_dt().substring(8,10);
		accid_dt_m 	= a_bean.getAccid_dt().substring(10,12);
	}
	
	ServOffDatabase sod 	= ServOffDatabase.getInstance();
	
	//���¾�ü �⺻���� ����
	
	if(user_id.equals("000047")){		//����������
		so_bean = sod.getServOff("000620");
	}else if(user_id.equals("000081")){	//����ī��ũ
		so_bean = sod.getServOff("001960");
	}else if(user_id.equals("000154")){	//����ũ��
		so_bean = sod.getServOff("006858");
	}else if(user_id.equals("000106")){	//�ΰ��ڵ�������
		so_bean = sod.getServOff("002105");
	}else if(user_id.equals("000110")){	//��������
		so_bean = sod.getServOff("001816");
	}else if(user_id.equals("000112")){	//����ī��ũ����
		so_bean = sod.getServOff("002734");
	}else if(user_id.equals("000143")){	//���������ڵ����������
		so_bean = sod.getServOff("000286");
	}
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���ΰ�ħ
	function reload_page(){
		var fm = document.form1;
		fm.target = '_self';
		fm.action = 'accid_gu.jsp';
		fm.submit();
	}
	
	//������ ���ฮ��Ʈ ��ȸ
	function res_search(){
		var fm = document.form1;	
		if(fm.c_id.value == ''){ alert('�����˻��� �ٽ� �Ͻʽÿ�.'); return; }	
		window.open("../accid_reg/search_res.jsp?c_id="+fm.c_id.value, "SEARCH_RES", "left=100, top=100, width=700, height=300, scrollbars=yes");		
	}
		
	//�����ϱ�	
	function save(){
		var fm = document.form1;
		dt_chk();
		if(fm.reg_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.reg_id.value == ''){ alert('�����ڸ� �����Ͻʽÿ�.'); return; }	
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		fm.target = 'i_no';
		fm.action = 'accid_u_a.jsp';
		fm.submit();
	}

	//������ �Ⱓ�� ����Ͻ� ��
	function dt_chk(){
		var fm = document.form1;	
		if(fm.car_st.value == '2' && fm.sub_rent_gu.value != '99'){
			var st_dt = replaceString("-","",fm.sub_rent_st.value);
			var et_dt = replaceString("-","",fm.sub_rent_et.value);
			var dt = replaceString("-","",fm.accid_dt.value);
			if(st_dt > dt || et_dt < dt){ 
				if(!confirm('������ ���Ⱓ�� ������ڰ� ���� �ʽ��ϴ�.\n\n����Ͻø� Ȯ���Ͻʽÿ�.\n\n�����Ͻø� �ϴ��� ������� ����Ͻõ� ������ �ֽʽÿ�.')){	return;	}	
			}
		}
	}	
		
	//�ϴܸ޴� �̵�
	function sub_in(idx){
		parent.c_foot.location.href = "accid_u_in"+idx+".jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&mode="+idx;		
	}	
	
	//��ϰ���
	function list(){
		var fm = document.form1;
		fm.target = 'd_content';
		if(fm.go_url.value == '')	fm.action = 'accid_s_frame.jsp';
		else						fm.action = fm.go_url.value;		
		fm.submit();
	}	

	//�����ø���
	function CarImgAdd(){
		var fm = document.form1;
		var SUBWIN="./car_img_adds.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&from_page=/acar/accid_mng/accid_gu.jsp";	
		window.open(SUBWIN, "CarImgAdd", "left=250, top=250, width=500, height=350, scrollbars=no");
	}	
	
	function ImgDelete(seq){
		var fm = document.form1;	
		fm.seq.value = seq;
		fm.wk_st.value = 'imgdel';
		if(fm.accid_id.value == ''){ alert("����� ���� ����Ͻʽÿ�."); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}		
		fm.target = "i_no"
		fm.submit();

	}
	
	function ServDelete(serv_id){
		var fm = document.form1;	
		fm.serv_id.value = serv_id;
		fm.wk_st.value = 'servdel';
		if(fm.accid_id.value == ''){ alert("����� ���� ����Ͻʽÿ�."); return; }
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}		
		fm.target = "i_no"
		fm.submit();

	}
	 	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	//����: ��ĵ ����
	function view_map(scan){
		var map_path = scan;
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=700, scrollbars=yes");
	}			
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='accid_gu_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		
<input type='hidden' name='from_page' value='/acar/accid_mng/accid_gu.jsp'>  		

<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="client_id" value='<%=cont.get("CLIENT_ID")%>'>
<input type='hidden' name="accid_dt" value='<%=accid_dt%>'>
<input type='hidden' name="seq" value=''>
<input type='hidden' name="wk_st" value=''>
<input type='hidden' name="serv_id" value=''>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>
						���󼼳���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr> 
	<tr>
		<td class=line2 colspan=2></td>
	</tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100% cellpadding=0>
                <tr> 
                    <td class=title width="8%">����ȣ</td>
                    <td width="12%">&nbsp;<%=l_cd%></td>
                    <td class=title width="8%">��ȣ</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%>
                    </td>
                    <td class=title width="8%">�����</td>
                    <td width="12%">&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width="8%">��뺻����</td>
                    <td width="13%">&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href="javascript:view_car()" title='�ڵ�����ϻ󼼳����� �˾��մϴ�.'><b><%=cont.get("CAR_NO")%></b></a></td>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=cont.get("USER_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td>&nbsp;<%=ins_com_nm%>
                      <%if(ins.getVins_spe().equals("�ִ�ī")){%>
                      (�ִ�ī) 
                      <%}%>
                    </td>
                    <td class=title>���ι��</td>
                    <td> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;���� 
                      <%}%>
                    </td>
                    <td class=title width=7%>�빰���</td>
                    <td width=11%> 
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5��� 
                      <%}%>
					  <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2��� 
                      <%}%>					  
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3õ���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1500���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1000���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5õ���� 
                      <%}%>
                    </td>
                    <td class=title>�ڱ��ü</td>
                    <td colspan="3">&nbsp;1�δ���/���: 
                      <%if(ins.getVins_bacdt_kd().equals("1")){%>
                      3��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("2")){%>
                      1��5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("3")){%>
                      3õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("4")){%>
                      1500���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("5")){%>
                      5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("6")){%>
                      1��� 
                      <%}%>
                      , 1�δ�λ�: 
                      <%if(ins.getVins_bacdt_kc2().equals("1")){%>
                      3��� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("2")){%>
                      1��5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("3")){%>
                      3õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("4")){%>
                      1500���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("5")){%>
                      5õ���� 
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("6")){%>
                      1��� 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>�� ������ȣ�� Ŭ���ϸ� �ڵ����󼼳����� �˾��˴ϴ�. ���⼭ �ڵ������������ ���� �� ��ĵ����� <b>�ڵ��������</b>�� ���� �ֽ��ϴ�.</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td align="right"> 
        <a href='javascript:list()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_list.gif align="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100% cellpadding=0>
                <tr> 
                    <td class=title width="8%">��������</td>
                    <td width="12%">&nbsp;<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%> 
                    </td>
                    <td class=title width="8%">������</td>
                    <td>&nbsp;<%=c_db.getNameById(a_bean.getReg_id(), "USER")%> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>�������</td>
                    <td> 
                      <%if(a_bean.getAccid_st().equals("1")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(a_bean.getAccid_st().equals("2")){%>
                      &nbsp;���� 
                      <%}%>
                      <%if(a_bean.getAccid_st().equals("3")){%>
                      &nbsp;�ֹ� 
                      <%}%>
                      <%if(a_bean.getAccid_st().equals("6")){%>
                      &nbsp; ����
                      <%}%>
                      <%if(a_bean.getAccid_st().equals("8")){%>
                      &nbsp;�ܵ� 
                      <%}%>
                    </td>
                    <td class=title>�����</td>
                    <td> 
                      <input type="checkbox" name="dam_type1" value="Y" <%if(a_bean.getDam_type1().equals("Y")){%>checked<%}%>  disabled>
                      ���� 
                      <input type="checkbox" name="dam_type2" value="Y" <%if(a_bean.getDam_type2().equals("Y")){%>checked<%}%>  disabled>
                      �빰 
                      <input type="checkbox" name="dam_type3" value="Y" <%if(a_bean.getDam_type3().equals("Y")){%>checked<%}%>  disabled>
                      �ڼ� 
                      <input type="checkbox" name="dam_type4" value="Y" <%if(a_bean.getDam_type4().equals("Y")){%>checked<%}%>  disabled>
                      ����</td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td> 
                      <%if(a_bean.getAccid_type().equals("1")){%>
                      &nbsp;������ 
                      <%}%>
                      <%if(a_bean.getAccid_type().equals("2")){%>
                      &nbsp;������ 
                      <%}%>
                      <%if(a_bean.getAccid_type().equals("3")){%>
                      &nbsp;�����ܵ� 
                      <%}%>
                      <%if(a_bean.getAccid_type().equals("4")){%>
                      &nbsp;���뿭�� 
                      <%}%>
                      </td>
                    <td class=title>����Ͻ�</td>
                    <td>
                      &nbsp;<%=AddUtil.ChangeDate2(accid_dt)%>
                      <%=accid_dt_h%>
                      �� 
                      <%=accid_dt_h%>
                      �� <font color="#808080">(�ð�:0-23)</font> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2" style='height:1; background-color:#d5d5d5;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
        <td align="right"> 
        <!-- ��û���� ������ �����ؼ� ����ϵ��� -->
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_accid_reg.jsp?car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=675,top=50,left=50')"><img src=/acar/images/center/button_reg_sgjb.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="4%">����</td>
                    <td class=title width="10%">��������</td>
                    <td class=title width="23%">�����ü��</td>
                    <td class=title width="11%">����ó</td>
                    <td class=title width="11%">�ѽ���ȣ</td>
                    <td class=title width="11%">����ݾ�</td>
                    <td class=title >���񳻿�</td>
                    <td class=title width="6%">����</td>
                    <td class=title width="6%">����</td>
                </tr>
              <%for(int i=0; i<s_r.length; i++){
        			s_bean = s_r[i];%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
        		
                    <td align="center"><%=s_bean.getOff_nm()%></td>
                    <td align="center"><%=s_bean.getOff_tel()%></td>
                    <td align="center"><%=s_bean.getOff_fax()%></td>
                    <td align="center"><%=AddUtil.parseDecimal(s_bean.getTot_amt())%>��</td>
                    <td align="center"> 
                      <%=s_bean.getRep_cont()%> 
                    </td>
                    <td align="center"> 
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        			  <%if(s_bean.getReg_id().equals(user_id) || s_bean.getOff_id().equals(so_bean.getOff_id())){%>
                      <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_accid_reg.jsp?car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&serv_id=<%=s_bean.getServ_id()%>&cmd=4','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                      <%}%>
        			  <%}%>
                    </td>
                    <td align="center">
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        			  <%if((s_bean.getReg_id().equals(user_id) || s_bean.getReg_id().equals("")) && !s_bean.getSac_yn().equals("Y")  && s_bean.getJung_st().equals("")  ){  %>   <!--��å��Ȯ���� �ȵ�, ����Ȱ� �ȵ�-->
                      <a href="javascript:ServDelete('<%=s_bean.getServ_id()%>')"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
                      <%}%>
                      <%}%>			  
        
        			</td>			
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2" style='height:1; background-color:#d5d5d5;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� ����</span></td>
        <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href="javascript:CarImgAdd()"><img src=/acar/images/center/button_reg_p.gif align=absmiddle border=0></a><%//}else{%><!--������ �����ϴ�.--><%}%>
	  &nbsp;&nbsp;<span class="b"><a href="javascript:reload_page()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a></span>
	  </td>
    </tr>
	<%if(size > 0){%>		
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
			<%for(int k=0; k<size; k++){
				s_idx = 6*k;			//0, 6,12,18...
				e_idx = 6*(k+1);		//6,12,18,24...%>
              <%if(size > s_idx){%>			
                <tr valign="top"> 
                    <%for(int i=s_idx; i<size && i<e_idx; i++){
                		p_bean = pa_r[i];%>
                    <td align="center" width=16% style='height:140'><a class=index1 href="javascript:MM_openBrWindow('big_imgs2.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq=<%=p_bean.getSeq()%>&filename=<%=p_bean.getFilename()%>','popwin0','scrollbars=no,status=no,resizable=yes,width=660,height=608,left=50, top=50')"> 
                      <img name="carImg" src="https://fms3.amazoncar.co.kr/images/accidImg/<%=p_bean.getFilename()%>.gif" border="0" width="130" height="98"></a><br>
                      <br>
					  <%=i+1%>�� 
					  <a href="javascript:ScanOpen('https://fms3.amazoncar.co.kr/images/accidImg/<%=p_bean.getFilename()%>.gif')" title='�������� ũ�� ����'><img src="/acar/images/large.gif" border="0"></a>
					  &nbsp;&nbsp;
        			  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:ImgDelete('<%=p_bean.getSeq()%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        			  <%}%>
        			  </td>
                    <%}%>
                    <%for(int i=size; i<e_idx; i++){%>
                    <td align="center" width=16% style='height:140'><img name="carImg" src="http://fms1.amazoncar.co.kr/images/no_photo.gif" border="0" width="130" height="98"></td>
                    <%}%>
                </tr>
                <%}%>				
			<%}%>
            </table>
        </td>
    </tr>
	<%}%>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
