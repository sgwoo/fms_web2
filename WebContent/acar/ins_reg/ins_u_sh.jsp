<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.cont.*, acar.tint.*, acar.offls_pre.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String go_url = request.getParameter("go_url")==null?"ins_s_frame.jsp":request.getParameter("go_url");
	if(go_url.equals(""))	go_url = "ins_s_frame.jsp";
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//���������ȣ
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = "0";
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	if(gubun.equals("cls"))	go_url = "../con_ins/ins_cls_frame.jsp";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(!c_id.equals("") && m_id.equals("") && l_cd.equals("")){
		RentListBean bean = ai_db.getLongRentCase(c_id);
		m_id = bean.getRent_mng_id();
		l_cd = bean.getRent_l_cd();
	}
	
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
	
	
	//��������
	Off_ls_pre_apprsl apprsl_bean = rs_db.getCarBinImg2(c_id);
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ϱ�	
	function save(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		fm.target = 'i_no';
		fm.action = 'ins_u_a.jsp';
		fm.submit();
	}
	
	//�ϴܸ޴� �̵�
	function sub_in(idx){
		var fm = document.form1;
		fm.target = 'c_foot';
		fm.action = "ins_u_in"+idx+".jsp";
		fm.submit();
	}	
	
	//��ϰ���
	function list(){
		var fm = document.form1;
		fm.target = 'd_content';
		<%if(go_url.equals("/acar/con_ins/ins_frame_s.jsp")){%>		
		fm.mode.value = '';
		fm.action = '<%=go_url%>';
		<%}else{%>
		fm.action = '<%=go_url%>';		
		<%}%>
		fm.submit();
	}	

	function view_client()
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=0", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=700, scrollbars=yes");
	}		
	function view_lcrent_car()
	{
		window.open("/fms2/lc_rent/lc_c_c_car.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&mode=view", "VIEW_LC_RENT_CAR", "left=120, top=120, width=850, height=600, scrollbars=yes");
	}		
	
	function search_car()
	{
//		window.open("ins_sm_frame.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=600, scrollbars=no");
		window.open("about:blank", "SEARCH_CAR", "left=100, top=200, width=850, height=600, scrollbars=no");
		var fm = document.form1;
//		fm.cmd.value = "ud";
		fm.target = 'SEARCH_CAR';
		fm.action = "ins_sm_frame.jsp";
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
	function move_cls(){	
		var fm = document.form1;	
		fm.action = "../ins_cls/ins_cls_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}		
	
	//�����ϱ�
	function del_insur(){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}		
		if(!confirm('���� �����Ͻðڽ��ϱ�?')){	return;	}		
		if(!confirm('��¥�� �����Ͻðڽ��ϱ�?')){	return;	}				
		fm.target = 'i_no';
//		fm.target = '_blank';		
		fm.action = 'ins_d_a.jsp';
		fm.submit();
	}	
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL;
		window.open(theURL,winName,features);
	}
	
	//�˾������� ����
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		window.open(theURL,winName,features);
	}		
	
	
	//���ڽ��������Ϻ�����
	function sendEmail_blackbox(blackbox_img, blackbox_img2, car_img1, car_img2){
		var fm = document.form1;
		fm.blackbox_img.value = blackbox_img;
		fm.blackbox_img2.value = blackbox_img2;
		fm.car_img1.value = car_img1;
		fm.car_img2.value = car_img2;
		window.open("about:blank", "ScdDocEmail", "left=50, top=50, width=700, height=450, scrollbars=yes");				
		fm.action = "ins_email_reg.jsp";
		fm.target = "ScdDocEmail";
		fm.submit();
		
		fm.blackbox_img.value = '';
		fm.blackbox_img2.value = '';
		fm.car_img1.value = '';
		fm.car_img2.value = '';
	}		
	
				
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='ins_u_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
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
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="client_id" value='<%=cont.get("CLIENT_ID")%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='blackbox_img' value=''>
<input type='hidden' name='blackbox_img2' value=''>
<input type='hidden' name='car_img1' value=''>
<input type='hidden' name='car_img2' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > ȯ�޺���� > <span class=style5>����󼼳���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=13%>&nbsp;<a href="javascript:view_lcrent_car()" title='<%=c_id%> <%=ins_st%>'><%=l_cd%></a></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=21%>&nbsp;<a href="javascript:view_client()"><%=cont.get("FIRM_NM")%></a></td>
                    <td class=title width=10%>�����</td>
                    <td width=12%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>��뺻����</td>
                    <td width=14%>&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title><a href="javascript:search_car()" title='<%=c_id%> <%=ins_st%>'>������ȣ</a></td>
                    <td>&nbsp;<a href="javascript:view_car()" title='<%=c_id%> <%=ins_st%>'><%=cont.get("CAR_NO")%></a></td>
                    <td class=title>����</td>
                    <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td></tr></table></td>
                    <td class=title>���ʵ����</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>�����ȣ</td>
                    <td>&nbsp;<%=cont.get("CAR_NUM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span> <font color="#999999">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(ins.getReg_dt())%>, 
        <img src=../images/center/arrow_ccdri.gif align=absmiddle> : <%=c_db.getNameById(ins.getReg_id(), "USER")%>, <img src=../images/center/arrow_cjdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(ins.getUpdate_dt())%>, 
        <img src=../images/center/arrow_cjdrj.gif align=absmiddle> : <%=c_db.getNameById(ins.getUpdate_id(), "USER")%>)</font></td>
        <td align="right"> 
        <%if(!cmd.equals("view")){%>
	        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    	    <a href='javascript:save()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
    	   	<%	}%>
			<%if(!go_url.equals("car_register")){%>		
	        &nbsp;<a href='javascript:list()'><img src=../images/center/button_list.gif align=absmiddle border=0></a> 
    	    <%}%>	
        	<!--<a href="javascript:history.go(-1);" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/reload.gif" width="50" height="18" aligh="absmiddle" border="0"></a>-->
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
                    <td class=title width=10%>��ϱ���</td>
                    <td width=13%>
                      &nbsp;<%if(ins.getIns_st().equals("0")){%>�ű�
                      <%}else{%>����(<%=ins.getIns_st()%>)<%}%></td>
                    <td class=title width=10%>��ϻ���</td>
                    <td width=21%>
                      &nbsp;<select name='reg_cau'>
                        <option value=''>===�ű�===</option>
                        <option value='1' <%if(ins.getReg_cau().equals("1")){%>selected<%}%>>1. ����</option>
                        <option value='2' <%if(ins.getReg_cau().equals("2")){%>selected<%}%>>2. �뵵����</option>
                        <option value='5' <%if(ins.getReg_cau().equals("5")){%>selected<%}%>>3. ��������</option>				
                        <option value=''>===����===</option>				
                        <option value='3' <%if(ins.getReg_cau().equals("3")){%>selected<%}%>>1. �㺸����</option>
                        <option value='4' <%if(ins.getReg_cau().equals("4")){%>selected<%}%>>2. ����</option>				
                      </select></td>
                    <td class=title width=10%>�㺸����</td>
                    <td width=12%>
                      &nbsp;<select name='ins_kd'>
                        <option value='1' <%if(ins.getIns_kd().equals("1")){%>selected<%}%>>���㺸</option>
                        <option value='2' <%if(ins.getIns_kd().equals("2")){%>selected<%}%>>å�Ӻ���</option>
                      </select></td>
                    <td class=title width=10%>�������</td>
                    <td width=14%>
                      &nbsp;<select name='ins_sts'>
                        <option value='1' <%if(ins.getIns_sts().equals("1")){%>selected<%}%>>��ȿ</option>
                        <option value='2' <%if(ins.getIns_sts().equals("2")){%>selected<%}%>>����</option>
                        <option value='3' <%if(ins.getIns_sts().equals("3")){%>selected<%}%>>�ߵ�����</option>
                        <option value='5' <%if(ins.getIns_sts().equals("5")){%>selected<%}%>>�°�</option>				
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td> 
                      &nbsp;<select name='ins_com_id'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title>����ȣ</td>
                    <td> 
                      &nbsp;<input type='text' name='ins_con_no' size='25' value='<%=ins.getIns_con_no()%>' class='text'>
                    </td>
                    <td class=title>�����</td>
                    <td> 
                      &nbsp;<input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title>�Ǻ�����</td>
                    <td> 
                      &nbsp;<input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>����Ⱓ</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24��&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24�� </td>
                    <td class=title>��������</td>
                    <td> 
                      &nbsp;<select name='car_use'>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>������</option>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>������</option>
						<option value='3' <%if(ins.getCar_use().equals("3")){%>selected<%}%>>���ο�</option>
                      </select>
                    </td>
                    <td class=title>���ɹ���</td>
                    <td> 
                      &nbsp;<select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻� 
                        </option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻� 
                        </option>
                        <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻� 
                        </option>
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������ 
                        </option>
                        <option value=''>=�Ǻ����ڰ�=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>												
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                  <td colspan="3">&nbsp; 
                      <input type='checkbox' name='air_ds_yn'   value='Y' <%if(ins.getAir_ds_yn().equals("Y")){%>checked<%}%>>
                      ������ 
                      <input type='checkbox' name='air_as_yn'   value='Y' <%if(ins.getAir_as_yn().equals("Y")){%>checked<%}%>>
                      ������
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(ins.getAuto_yn().equals("Y")){%>checked<%}%> >
                      �ڵ����ӱ�
                      <input type="checkbox" name="abs_yn" 	value="Y" <%if(ins.getAbs_yn().equals("Y")){%>checked<%}%> >
                      ABS��ġ
                      <input type="checkbox" name="blackbox_yn" value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>checked<%}%> >
                      ���ڽ�
                      <%	Hashtable tint = t_db.getInsurBlackboxImgs(ins.getCar_mng_id());   
                      		if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("") && !String.valueOf(tint.get("BLACKBOX_IMG")).equals("null")){                   		
                      			if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("")){                   		
                      %>
                          &nbsp;��:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.get("BLACKBOX_IMG") %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
                      <%		}
                      			if(!String.valueOf(tint.get("BLACKBOX_IMG2")).equals("")){                   		
                      %>    
                          &nbsp;�ǳ�:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.get("BLACKBOX_IMG2") %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
                      <%		}
                      %>
                      <%		if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("") && !String.valueOf(tint.get("BLACKBOX_IMG2")).equals("")){%>                        
                          &nbsp;<a href="javascript:sendEmail_blackbox('<%=tint.get("BLACKBOX_IMG")%>', '<%=tint.get("BLACKBOX_IMG2")%>','','')"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a>                        
                      <%		}%>
                      <%	}else{%>
                      <%		if(!apprsl_bean.getImgfile5().equals("")){%>
                          &nbsp;��:<a href="javascript:MM_openBrWindow2('/images/carImg/<%= apprsl_bean.getImgfile5() %>.gif','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                      
                      <%		}%>
                      <%		if(!apprsl_bean.getImgfile2().equals("")){%>
                          &nbsp;�ǳ�:<a href="javascript:MM_openBrWindow2('/images/carImg/<%= apprsl_bean.getImgfile2() %>.gif','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                      
                      <%		}%>
                      <%		if(!apprsl_bean.getImgfile2().equals("") && !apprsl_bean.getImgfile5().equals("")){%>                        
                          &nbsp;<a href="javascript:sendEmail_blackbox('','','<%=apprsl_bean.getImgfile5()%>.gif', '<%=apprsl_bean.getImgfile2()%>.gif')"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a>                        
                      <%		}%>
                      <%	}%>
                      ��������������Ư��
                      <select name='com_emp_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
                    </td>
                    <td class='title'>���԰����</td>
                    <td> 
                      &nbsp;<input type='text' name='car_rate' size='5' maxlength='30' value='<%=ins.getCar_rate()%>' class='text'>
                      % </td>
                    <td class='title'>����������</td>
                    <td> 
                      &nbsp;<input type='text' name='ext_rate' size='5' maxlength='30' value='<%=ins.getExt_rate()%>' class='text'>
                      % </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr align="center"> 
        <td colspan="2"> 
            <a href="javascript:sub_in(1)"><img src=../images/center/button_ins_cy.gif align=absmiddle border=0></a>
    		<%//if(ins.getIns_kd().equals("1")){%> 
    	    &nbsp;<a href="javascript:sub_in(2)"><img src=../images/center/button_ins_bg.gif align=absmiddle border=0></a>
    		<%//}%>
            &nbsp;<a href="javascript:sub_in(3)"><img src=../images/center/button_ins_sch.gif align=absmiddle border=0></a> 
            &nbsp;<a href="javascript:sub_in(7)"><img src=../images/center/button_ins_ggby.gif align=absmiddle border=0></a> 		
    		&nbsp;<a href="javascript:sub_in(4)"><img src=../images/center/button_ins_hj.gif align=absmiddle border=0></a> 
            &nbsp;<a href="javascript:sub_in(5)"><img src=../images/center/button_ins_ir.gif align=absmiddle border=0></a> 
    		&nbsp;<a href="javascript:sub_in(6)"><img src=../images/center/button_ins_acc.gif align=absmiddle border=0></a> 
			<%if(!cmd.equals("view")){%>
            &nbsp;&nbsp;&nbsp;<a href="javascript:move_reg()"><img src=../images/center/button_ins_gs.gif align=absmiddle border=0></a> 
    		<%	if(ins.getIns_sts().equals("1")){%>
            &nbsp;&nbsp;&nbsp;<a href="javascript:move_cls()"><img src=../images/center/button_ins_hji.gif align=absmiddle border=0></a> 		
    		<%	}%>
			<%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������",user_id) ){%>
			&nbsp;&nbsp;<a href='javascript:del_insur()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>
			<%	}%>
			<%}%>
			
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
<script language='javascript'>
<!--
<%if(!cmd.equals("view")){%>
	var fm = document.form1;
	//�ٷΰ���
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;		
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
<%}%>	
//-->
</script>  
</body>
</html>

