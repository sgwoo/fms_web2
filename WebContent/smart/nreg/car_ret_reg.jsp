<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}

#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}



</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.res_search.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_s_cd		= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");

	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	//��������
	Hashtable reserv = rs_db.getCarInfo(car_mng_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();

	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();

	String ment = "";
	String gubun = "";

	if((rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("6")) && rc_bean.getServ_id().equals("")){
		ment = "����� ������� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.";
		gubun = "s";
	}else if((rc_bean.getRent_st().equals("3") || rc_bean.getRent_st().equals("8")) && rc_bean.getAccid_id().equals("")){
		ment = "���� ������� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.";
		gubun = "a";
	}

	if(rc_bean.getDeli_mng_id().equals("")){
		//�����
		user_bean 	= umd.getUsersBean(user_id);
	}else{
		//�����
		user_bean 	= umd.getUsersBean(rc_bean.getDeli_mng_id());
	}

    //������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//��������ã��
	function search_car(){
		var fm = document.form1;
		var SUBWIN="search_ret_car_list.jsp?t_wd=&self_st=Y";
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}

	//����ϱ�
	function DistReg(){
		var fm = document.form1;

		<%if(rent_s_cd.equals("")){%>
		if(fm.rent_s_cd.value == '')	{ alert('����� ��ȸ�Ͻʽÿ�'); 	return; }
		<%}%>

		if((fm.rent_st.value == '2' || fm.rent_st.value == '6') && fm.serv_id.value == '' && fm.ment.value != ''){ alert('����� ������� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if((fm.rent_st.value == '3' || fm.rent_st.value == '8') && fm.accid_id.value == '' && fm.ment.value != ''){ alert('���� ������� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.ret_dt.value == ''){ 		alert('�����Ͻø� �Է��Ͻʽÿ�'); 			fm.ret_dt.focus(); 			return; }
		if(fm.ret_loc.value == ''){ 	alert('������ġ�� �Է��Ͻʽÿ�'); 			fm.ret_loc.focus(); 		return; }
		if(fm.ret_mng_id.value == ''){ 	alert('��������ڸ� �����Ͻʽÿ�'); 		fm.ret_mng_id.focus(); 		return; }
		if(fm.ret_dt.value != '')
			fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value+fm.ret_dt_s.value;

//		if(replaceString('-','',fm.h_ret_dt.value) == fm.h_deli_dt.value){ alert('�����Ͻÿ� �����Ͻð� ������ ����ó������ �ʽ��ϴ�. ���ó�� �ϼ���.'); return; }


		if(!confirm('����Ͻðڽ��ϱ�?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'car_ret_reg_a.jsp';
//		fm.target = "i_no";
		fm.target = "_self";
		fm.submit();

	}

	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
		var fm = document.form1;
		if(fm.rent_st.value == '1') 	return;
		if(fm.ret_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�'); fm.ret_dt.focus(); return; }
		if(fm.h_rent_end_dt.value == '')	fm.h_rent_end_dt.value = replaceString('-','',fm.ret_dt.value)+fm.ret_dt_h.value+fm.ret_dt_s.value;

		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var d3;
		var d4;
		var t1;
		var t2;
		var t3;
		var t4;
		var t5;
		var t6;

		d1 = fm.h_rent_start_dt.value;
		d2 = fm.h_rent_end_dt.value;
		d3 = fm.h_deli_dt.value;
		d4 = replaceString('-','',fm.ret_dt.value)+fm.ret_dt_h.value+fm.ret_dt_s.value;

		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;

		if(t3 == t6){
			fm.add_months.value = 0;
			fm.add_days.value = 0;
			fm.add_hour.value = 0;
			if(fm.rent_months.value == '0' && fm.rent_days.value == '0' && fm.rent_hour.value == '0'){
				fm.rent_months.value = parseInt(t3/m);
				fm.rent_days.value = parseInt((t3%m)/l);
				fm.rent_hour.value = parseInt(((t3%m)%l)/lh);
			}
			fm.tot_months.value = fm.rent_months.value;
			fm.tot_days.value = fm.rent_days.value;
			fm.tot_hour.value = fm.rent_hour.value;

		}else{//�ʰ� or �̸�
			fm.add_months.value 	= parseInt((t6-t3)/m);
			fm.add_days.value 		= parseInt(((t6-t3)%m)/l);
			fm.add_hour.value 		= parseInt((((t6-t3)%m)%l)/lh);
			fm.tot_months.value 	= parseInt(t6/m);
			fm.tot_days.value 		= parseInt((t6%m)/l);
			fm.tot_hour.value 		= parseInt(((t6%m)%l)/lh);
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}

	//���� ��ȸ
	function search_serv_car(){
		var fm = document.form1;
		var SUBWIN="search_serv_car_list.jsp?s_kd=1&t_wd=<%=rc_bean2.getFirm_nm()%>";
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}


	//��� ��ȸ
	function search_accid_car(){
		var fm = document.form1;
		var SUBWIN="search_accid_car_list.jsp?s_kd=1&t_wd=<%=rc_bean2.getFirm_nm()%>";
		window.open(SUBWIN, "SubCust", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}

	function page_reload()
	{
		var fm = document.form1;
		fm.action = "car_ret_reg.jsp";
		fm.target = "_self";
		fm.submit();
	}


	function view_before()
	{
		var fm = document.form1;
		<%if(rent_s_cd.equals("")){%>
		fm.action = "nreg_main.jsp";
		<%}else{%>
		fm.action = "car_ret_view.jsp";
		<%}%>
		fm.target = "_self";
		fm.submit();
	}
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='rent_s_cd'	value='<%=rent_s_cd%>'>
	<input type='hidden' name='cmd' 		value=''>
	<input type='hidden' name='from_page'	value='car_ret_reg.jsp'>

	<input type='hidden' name='rent_st' 	value='<%=rc_bean.getRent_st()%>'>
 	<input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 	<input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 	<input type='hidden' name='h_deli_dt' 	value='<%=rc_bean.getDeli_dt()%>'>
 	<input type='hidden' name='h_ret_dt' 	value='<%=rc_bean.getRet_dt()%>'>
 	<input type='hidden' name='ment' 		value='<%=ment%>'>
 	<input type="hidden" name="serv_id" 	value="<%=rc_bean.getServ_id()%>">
 	<input type="hidden" name="accid_id" 	value="<%=rc_bean.getAccid_id()%>">
 	<input type='hidden' name='sub_c_id' 	value='<%=rc_bean.getSub_c_id()%>'>
 	<input type='hidden' name='sub_l_cd' 	value='<%=rc_bean.getSub_l_cd()%>'>
 	<input type='hidden' name='c_car_no' 	value='<%=rc_bean2.getCar_no()%>'>
 	<input type='hidden' name='serv_dt' 	value=''>
 	<input type='hidden' name='car_nm' 		value=''>
 	<input type='hidden' name='our_num' 	value=''>
 	<input type='hidden' name='ins_nm' 		value=''>
 	<input type='hidden' name='ins_mng_nm' 	value=''>
 	<input type='hidden' name='car_no' 		value='<%=reserv.get("CAR_NO")%>'>
 	<input type='hidden' name='c_firm_nm' 	value='<%=rc_bean2.getFirm_nm()%>'>
 	<input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>




<div id="wrap">
    <div id="header">
        <div id="gnb_box">
			<div id="gnb_login">�������������</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='����ȭ�� ����'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�������&nbsp;
		<a href="javascript:search_car()" onMouseOver="window.status=''; return true" title="������ȸ�ϱ�. Ŭ���ϼ���"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		</div>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">

			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>��౸��</th>
							<td valign=top><%if(rent_st.equals("1")){%>
                &nbsp;�ܱ�뿩
                <%}else if(rent_st.equals("2")){%>
                &nbsp;�������
                <%}else if(rent_st.equals("3")){%>
                &nbsp;������
                <%}else if(rent_st.equals("9")){%>
                &nbsp;�������
                <%}else if(rent_st.equals("10")){%>
                &nbsp;��������
                <%}else if(rent_st.equals("4")){%>
                &nbsp;�����뿩
                <%}else if(rent_st.equals("5")){%>
                &nbsp;��������
                <%}else if(rent_st.equals("6")){%>
                &nbsp;��������
                <%}else if(rent_st.equals("7")){%>
                &nbsp;��������
                <%}else if(rent_st.equals("8")){%>
                &nbsp;������
                <%}else if(rent_st.equals("11")){%>
                &nbsp;�����
                <%}%>		</td>
						</tr>
						<tr>
							<th valign=top>������ȣ</th>
							<td valign=top><font color=#fd5f00><%=reserv.get("CAR_NO")==null?"":reserv.get("CAR_NO")%></font></td>
						</tr>
						<tr>
							<th valign=top>����</th>
							<td valign=top><%=reserv.get("CAR_NM")==null?"":reserv.get("CAR_NM")%></td>
						</tr>
						<tr>
							<th valign=top>��ȣ</th>
							<td valign=top><%=rc_bean2.getFirm_nm()%> <%=rc_bean2.getCust_nm()%></td>
						</tr>
						<tr>
							<th valign=top>�����Ͻ�</th>
							<td valign=top><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> <%=rc_bean.getDeli_dt_h()%>�� <%=rc_bean.getDeli_dt_s()%>��</td>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%if(!ment.equals("")){%>
		<%		if(rent_st.equals("3")){//������� ��ȸ%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">�������
		<a href="javascript:search_accid_car()" onMouseOver="window.status=''; return true" title="������ȸ�ϱ�. Ŭ���ϼ���"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		</div>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">

			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>�������</th>
							<td><input type="text" name="accid_car_no" value="" size="30" class=whitetext></td>
						</tr>
				    	<tr>
				    		<th width="70">��������</th>
				    		<td><input type="text" name="off_nm" value="" size="30" class=whitetext></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%		}else{%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������
		<a href="javascript:search_serv_car()" onMouseOver="window.status=''; return true" title="������ȸ�ϱ�. Ŭ���ϼ���"><img src="/smart/images/btn_serch.gif"  border="0" align=absmiddle></a>
		</div>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">

			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="70">��������</th>
				    		<td><input type="text" name="off_nm" value="" size="45" class=whitetext></td>
				    	</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<%		}%>
		<%}%>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">��������</div>
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">

			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>���������Ͻ�</th>
							<td><%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
						</tr>
				    	<tr>
				    		<th width="70">�����Ͻ�</th>
				    		<td><input type="text" name="ret_dt" value="<%=AddUtil.getDate()%>" size="11" class=whitetext readonly onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <select name="ret_dt_h" onchange="javscript:getRentTime();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" onchange="javscript:getRentTime();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
							</td>
				    	</tr>
						<tr>
							<th>������ġ</th>
							<td><textarea name="ret_loc" cols="30" rows="3" class="text" style="IME-MODE: active"><%=rc_bean.getRet_loc()%></textarea></td>
						</tr>
						<tr>
							<th>��������ġ</th>
							<td>
                                <SELECT NAME="park" >
        							<%for(int i = 0 ; i < good_size ; i++){
        	                  				CodeBean good = goods[i];%>
        	                        <option value='<%= good.getNm_cd()%>'
        	                        	<%if( (user_bean.getBr_id().equals("S1")|| user_bean.getBr_id().equals("S2")|| user_bean.getBr_id().equals("I1") || user_bean.getBr_id().equals("K3")) & good.getNm_cd().equals("1")){%> selected
        	                        	<%}else if( user_bean.getBr_id().equals("B1") & good.getNm_cd().equals("8")){%>selected
        	                        	<%}else if( user_bean.getBr_id().equals("D1") & good.getNm_cd().equals("4")){%>selected
        	                        	<%}else if( user_bean.getBr_id().equals("J1") & good.getNm_cd().equals("12")){%>selected
        	                        	<%}else if( user_bean.getBr_id().equals("G1") & good.getNm_cd().equals("13")){%>selected
        	                        	<%}%>><%= good.getNm()%>
        	                        </option>
        	                        <%}%>
                    			
        		        </SELECT>
						<br>
						<textarea name="park_cont" cols="30" rows="3" class="text" style="IME-MODE: active"></textarea>
						<br>(��Ÿ���ý� ����)</td>
						</tr>
						<tr>
							<th>���������</th>
							<td><select name='ret_mng_id'>
                        <option value="">������</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select></td>
						</tr>
						<%if(!rent_st.equals("1") && !rent_st.equals("9")){%>
						<tr id=tr_time1 style='display:none'>
							<th>���ʾ����ð�</th>
							<td><input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=num>
                      �ð�
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=num>
                      ��
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=num>
                      ����</td>
						</tr>
						<tr id=tr_time2 style='display:none'>
							<th>�߰��̿�ð�</th>
							<td><input type="text" name="add_hour" value="" size="2" class=num >
                      �ð�
                      <input type="text" name="add_days" value="" size="2" class=num >
                      ��
                      <input type="text" name="add_months" value="" size="2" class=num >
                      ����</td>
						</tr>
						<tr id=tr_time3 style='display:none'>
							<th>���̿�ð�</th>
							<td><input type="text" name="tot_hour" value="" size="2" class=num >
                      �ð�
                      <input type="text" name="tot_days" value="" size="2" class=num >
                      ��
                      <input type="text" name="tot_months" value="" size="2" class=num >
                      ����</td>
						</tr>
						<tr>
							<th>��������Ÿ�</th>
							<td><input type="text" name="run_km" value="" size="10" class=text>
                      &nbsp;km</td>
						</tr>
						<tr>
							<th>���</th>
							<td><textarea name="etc" cols="30" rows="3" class="text" style="IME-MODE: active"></textarea></td>
						</tr>
						<%}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>

	</div>
	<div id="cbtn"><a href="javascript:DistReg();"><img src=/smart/images/btn_reg.gif align=absmiddle border=0></a></div>
	<div id="footer"></div>
</div>
</form>
<script language="JavaScript">
<!--
	getRentTime()
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
