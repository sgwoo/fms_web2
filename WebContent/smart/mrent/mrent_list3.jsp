<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS_Search_Cont</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

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
#wrap {float:left; margin:0 auto; width:100%; background-color:#fff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* �˻�â */
#search fieldset {padding:0px 0px; border:0px; text-align:center;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .title {float:left; margin-right:10px; height:40px;}
#search .userform .name { margin:0 20px 0 45px;}
#search .userform .userinput {padding-right:50px; height:40px; margin:0 20px 0 50px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:20px;}

/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
.srch .white{margin-left:1px;padding:2px 3px 5px;border:0px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* ����Ʈ */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '�������'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '�������';}

td {padding:6px 0 4px 0; border:0px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '�������';}

#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:0 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:2px 0 3px;font-size:16px;color:#000;line-height:17px;font-weight:bold;display:block;}
.List li a em {color:#888;font-size:16px;}
.List .list1{float:left;margin-right:10px;}
.List .list2{height:33px;display:block;overflow:hidden;padding:0.8em 0px 0.3em;_float:left;_padding-right:1em;white-space:nowrap;text-overflow:ellipsis;}
</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*, acar.off_ls_hpg.*, acar.secondhand.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>

<%//@ include file="/smart/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String rent_start_dt = request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt = request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	String st = request.getParameter("st")==null?"":request.getParameter("st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(st_dt.equals("") && end_dt.equals("")){
	
		st_dt = AddUtil.getDate();
		end_dt = c_db.addMonth(st_dt , 1);
		end_dt = c_db.addDay(end_dt, -1); //-1
		
	}
	
	Hashtable ht = new Hashtable();
	
	if(!st.equals("st")){
		 ht = oh_db.getYearMonthDay3(AddUtil.replace(st_dt,"-",""), AddUtil.replace(end_dt,"-",""));
	}else{
		 ht = oh_db.getYearMonthDay4(AddUtil.replace(st_dt,"-",""), AddUtil.replace(rent_end_dt,"-",""));
	}

%>
<%
	
	String slt_car_com = request.getParameter("slt_car_com")==null?"":request.getParameter("slt_car_com");//car_comp_id����
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String slt_car_nm = request.getParameter("slt_car_nm")==null?"":request.getParameter("slt_car_nm"); //car_cd�Ͱ���
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("slt_car_nm");		//code���� ����.ó���� car_cd�� �ϴٰ� ��ħ.

	String car_cc = request.getParameter("car_cc")==null?"":request.getParameter("car_cc");
	int car_year = request.getParameter("car_year")==null?0:Util.parseDigit(request.getParameter("car_year"));
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun = request.getParameter("sort_gubun")==null?"asc":request.getParameter("sort_gubun");
	
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String brch_id 		= request.getParameter("brch_id")	==null?"S1":request.getParameter("brch_id");//����
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");//����
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String res_mon_yn	= "Y";  //����Ʈ
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");//��ü����
	
	String gubun = request.getParameter("gubun")==null?"2":request.getParameter("gubun");
	String res_yn = request.getParameter("res_yn")==null?"":request.getParameter("res_yn");//���������
	String list_sort = request.getParameter("list_sort")==null?"":request.getParameter("list_sort");
	
	//�˻�-������Ʈ
	Vector vt_hd2 		= oh_db.getMrent_Cars2_nm               (gubun2, gubun, car_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn, AddUtil.parseInt(String.valueOf(ht.get("MONTHS"))),AddUtil.parseInt(String.valueOf(ht.get("DAYS"))));

	//����Ʈ��������Ʈ	
	Vector secondhandList 	= oh_db.getSecondhandMonthsList_20131210(gubun2, gubun, car_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn, AddUtil.parseInt(String.valueOf(ht.get("MONTHS"))),AddUtil.parseInt(String.valueOf(ht.get("DAYS"))));
	
	//������ , ����, ����
	String year = AddUtil.getDate().substring(2, 4);

	CodeBean[] companys = c_db.getCodeAll("0001"); /* �ڵ� ����:�ڵ���ȸ�� */
	int com_size = companys.length;
	int car_size = 0;
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String real_km = request.getParameter("real_km")==null?"":request.getParameter("real_km");
	String apply_sh_pr = request.getParameter("apply_sh_pr")==null?"":request.getParameter("apply_sh_pr");
	String upload_dt = request.getParameter("upload_dt")==null?"":request.getParameter("upload_dt");
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String amt = request.getParameter("amt")==null?"":request.getParameter("amt");
	
	double rm = 0;
	double tot_rm = 0;
	double rm1 = 0;
	double tot_rm1 = 0;
	double rm2 = 0;
	double tot_rm2 = 0;
	double per = 0;
	int rm_mon = 0;
	int rm_day = 0;
%>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
	function search(gu,cal_Day){
		var fm = document.form1;
		fm.list_sort.value = '';
		if(gu=='st'){
			fm.rent_start_dt.value = cal_Day ;
			fm.st.value = gu;
			fm.r_day.value = 0;
		}else{
			
		}
		fm.target =  "_self";
		fm.action =  "mrent_list3.jsp";
		fm.submit();
	}
	
 	//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name="form1" method="post" action='mrent_list3.jsp'> 
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>  
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='cp' value=''>
<input type='hidden' name='st' value=''>
<input type='hidden' name='list_sort' value='<%=list_sort%>'>
<!--������,����,��-->
<input type='hidden' name='com_id' value='<%= com_id %>'>
<input type='hidden' name="car_cd" value="<%= car_cd %>">	

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">����Ʈ �̴뿩 �����˻�</div>
            <div id="gnb_home">
				<a href='/smart/main.jsp' title='Ȩ'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>

    <div id="contents">
    	<div id="search">
	        <fieldset>
	        	<div class="userform" >
						<select name="gubun2" style="width:200px;">
							<option value="" <% if(gubun2.equals("")) out.print("selected"); %>>��������</option>
							<option value="8" <% if(gubun2.equals("8")) out.print("selected"); %>>�����������¿�(LPG)</option>
							<option value="4" <% if(gubun2.equals("4")) out.print("selected"); %>>�����¿�(LPG)</option>
							<option value="3" <% if(gubun2.equals("3")) out.print("selected"); %>>�����¿�/��¿�(���ָ�/����)</option>
							<option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>�����¿�(���ָ�/����)</option>
							<option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>�����¿�(���ָ�)</option>
							<option value="6" <% if(gubun2.equals("6")) out.print("selected"); %>>RV</option>
						</select>
						<br/>
						<select name="brch_id" style="width:200px;">
							<option value=""  <% if(brch_id.equals("")) out.print("selected"); %> >��������</option>
							<option value="S1"  <% if(brch_id.equals("S1")) out.print("selected"); %>>������</option>
							<option value="D1"  <% if(brch_id.equals("D1")) out.print("selected"); %>>����</option>
							<option value="G1"  <% if(brch_id.equals("G1")) out.print("selected"); %>>�뱸</option>
							<option value="J1"  <% if(brch_id.equals("J1")) out.print("selected"); %>>����</option>
							<option value="B1"  <% if(brch_id.equals("B1")) out.print("selected"); %>>�λ�</option>
						</select>
						<br/>
						<select name="gubun" style="width:200px;">
							<option value="" <% if(gubun.equals("")) out.print("selected"); %>>����Ȳ����</option>
							<option value="2" <% if(gubun.equals("2")) out.print("selected"); %>>��ð�������</option>
							<option value="1" <% if(gubun.equals("1")) out.print("selected"); %>>3���̳� ��������</option>
						</select>
						<br/>
						<select name="car_nm" style="width:200px;" >
							<option value="" <%if(car_nm.equals(""))%>selected<%%>>������</option>
							<%
								String f_car_nm2 = "";
								int cnt2 = 0, name_cnt2 = 0;

								for(int n=0; n<vt_hd2.size(); n++){
									Hashtable ht2 = (Hashtable)vt_hd2.elementAt(n);

									if(n==0){					
										f_car_nm2 = (String)ht2.get("CAR_NM");
								
									}
									String l_car_nm2 = (String)ht2.get("CAR_NM");
							%>	
							<% 		if(f_car_nm2.equals(l_car_nm2)){
										cnt2++;
									}else{
										f_car_nm2 = l_car_nm2;
								
							%>
							<% 			cnt2 = 1; %>
							<% 		} %>
									<option value="<%= (String)ht2.get("CAR_NM") %>"  <%if(car_nm.equals((String)ht2.get("CAR_NM")))%>selected<%%>>[<%=(String)ht2.get("COM_NM")%>]<%= (String)ht2.get("CAR_NM") %><%if(ht2.get("CAR_NM").equals("���")&&ht2.get("FUEL_KD").equals("3")){%>LPG<%}%></option>
							<%	}%>
						</select>
					</div>
					<br/>
						<a href="javascript:search()"><img src="/smart/images/btn_srch.gif" alt="�˻�" value="�˻�"></a>
			</fieldset> 
		</div>
		<br>

		<tbody>
			<%	if( secondhandList.size() >0){

					for(int i=0; i < secondhandList.size(); i++){
						Hashtable secondhand = (Hashtable)secondhandList.elementAt(i);
					
					//�뿩��� ����
					rm = AddUtil.parseDouble(String.valueOf(secondhand.get("RM1"))); //�⺻���뿩��
					per = AddUtil.parseDouble(String.valueOf(secondhand.get("PER"))); //�ۼ�Ʈ
					

					if(st.equals("st")){
						rm_mon = 1;
						rm_day = 0;
					}else{
						rm_mon = AddUtil.parseInt(String.valueOf(ht.get("MONTHS")));	//�̿�Ⱓ ��
						rm_day = AddUtil.parseInt(String.valueOf(ht.get("DAYS")));		//�̿�Ⱓ ��
					}
					car_mng_id = String.valueOf(secondhand.get("CAR_MNG_ID"));

					tot_rm = Math.round(rm * (1-per))/1000*1000;  //����뿩��-������뿩��
			
					tot_rm1 = Math.round((tot_rm * rm_mon + tot_rm * rm_day/30))/1000*1000;  //����뿩��- 0���� 0��
					
					real_km =String.valueOf(secondhand.get("REAL_KM"));
					apply_sh_pr =String.valueOf(secondhand.get("APPLY_SH_PR"));
					upload_dt =String.valueOf(secondhand.get("UPLOAD_DT"));
					reg_code =String.valueOf(secondhand.get("REG_CODE"));
					amt =String.valueOf(secondhand.get("RM1"));
					
			%>
		<ul class="List">
			<li> <span>&nbsp;</span>  
				
				<%if(!String.valueOf(secondhand.get("IMGFILE6")).equals("")){%>
					<a href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=secondhand.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=600,left=50, top=50')" title="�������� ũ�� ����">
					<span class='list1'><img src="https://fms3.amazoncar.co.kr/images/carImg/<% if(String.valueOf(secondhand.get("IMGFILE6")).equals("")) out.print("no_photo"); else out.print(secondhand.get("IMGFILE6")); %>.gif" border=0 width=71 height=53 class="photo"></span></a>
				<%}else{%>	
					<span class='list1'><img src="https://fms3.amazoncar.co.kr/images/carImg/<% if(String.valueOf(secondhand.get("IMGFILE6")).equals("")) out.print("no_photo"); else out.print(secondhand.get("IMGFILE6")); %>.gif" border=0 width=71 height=53 class="photo"></span></a>
					<%}%>
				
				<span>
					<b><%= secondhand.get("JG_V") %></b><br/>
					<font color="#990000"><%=secondhand.get("CAR_NO")%></font>
				<br/>
				
					<%if(AddUtil.parseInt(String.valueOf(secondhand.get("RM1")))>0){%><b><a href="javascript:EstiPrintRm('2','1','1','<%=secondhand.get("RM1")%>','<%=secondhand.get("CAR_MNG_ID")%>','<%=reg_code%>','<%=AddUtil.parseDecimal(tot_rm1)%>','<%=AddUtil.parseDecimal(tot_rm)%>','<%=real_km%>','<%=apply_sh_pr%>','<%=upload_dt%>','<%=per%>','<%=secondhand.get("BR_ID")%>');"><font color="#990000"><%=AddUtil.parseDecimal(tot_rm)%>&nbsp;
					</font></a></b><%}%>&nbsp;
				</span>
				<span><%= secondhand.get("FUEL_KD") %>/<%= secondhand.get("INIT_REG_DT") %>��/<%= AddUtil.parseDecimal((String)secondhand.get("REAL_KM")) %>km<br>
					<%= secondhand.get("COLO") %>/<%= secondhand.get("CAR_NAME") %>/
					<%if(secondhand.get("BR_ID").equals("S1")){%>
						������
					<%}else if(secondhand.get("BR_ID").equals("D1")){%>
						����
					<%}else if(secondhand.get("BR_ID").equals("G1")){%>
						�뱸
					<%}else if(secondhand.get("BR_ID").equals("J1")){%>
						����
					<%}else if(secondhand.get("BR_ID").equals("B1")){%>
						�λ�
					<%}%>
				</span>
				<br/>
				<span><!-- rm_st = ���˿� �� ���� ��ð������� ���.  -->
					<%if (secondhand.get("RM_ST").equals("������")&& secondhand.get("RENT_ST").equals("���")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_serv.png alt="�����" width="65" height="22">
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && secondhand.get("RENT_ST").equals("��������")&& !secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_rep.png alt="������" width="65" height="22">
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && secondhand.get("RENT_ST").equals("���") && !secondhand.get("RM_ST").equals("������") && secondhand.get("PARK_YN").equals("P")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_rnow.png alt="��ð���" width="65" height="22">
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && secondhand.get("RENT_ST").equals("���") && secondhand.get("RM_ST").equals("���˿�") && secondhand.get("PARK_YN").equals("")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_rep.png alt="������" width="65" height="18">
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && secondhand.get("RENT_ST").equals("���") && secondhand.get("RM_ST").equals("���") && secondhand.get("PARK_YN").equals("")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_rep.png alt="������" width="65" height="22">	
						
					<%}else if ( secondhand.get("SITUATION").equals("�����") && secondhand.get("RENT_ST").equals("���")&& !secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon.png align=absmiddle alt="�����" width="65" height="22"><br/>
						<% if(!secondhand.get("RES_END_DT").equals("")){%>������Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RES_END_DT"))%><%}%>
						
					<%}else if ( secondhand.get("SITUATION").equals("�����")&&(secondhand.get("RENT_ST").equals("������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("��������") ||secondhand.get("RENT_ST").equals("��������")  ) && !secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon.png align=absmiddle alt="�����" width="65" height="22">
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon_dc.png align=absmiddle alt="������" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�������Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && (secondhand.get("RENT_ST").equals("������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("��������")  )&& !secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon_dc.png align=absmiddle alt="������" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�������Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>

					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && (secondhand.get("RENT_ST").equals("����Ʈ")||secondhand.get("RENT_ST").equals("�ܱ�뿩")) && !secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_lend.png align=absmiddle alt="�뿩��" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�뿩���Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>
						
					<%}else if ( secondhand.get("SITUATION").equals("���డ��") && secondhand.get("RENT_ST").equals("����Ʈ") && secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_lend.png align=absmiddle alt="�뿩��" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�뿩���Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>	
						
					<%}else if ( secondhand.get("SITUATION").equals("�����") && secondhand.get("RENT_ST").equals("����Ʈ")&& !secondhand.get("RM_ST").equals("������") ) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon.png align=absmiddle alt="�����" width="65" height="22">
						<img src=http://fms.amazoncar.co.kr/home/images/sub/btn_lend.png align=absmiddle alt="�뿩��" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�뿩���Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>
						
					<%}else if (secondhand.get("SITUATION").equals("���డ��")&&(secondhand.get("RENT_ST").equals("������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("��������") ||secondhand.get("RENT_ST").equals("��������")  ) && secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon_dc.png align=absmiddle alt="������" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�������Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>	
					
					<%}else if ( secondhand.get("SITUATION").equals("�����")&&(secondhand.get("RENT_ST").equals("������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("�������")||secondhand.get("RENT_ST").equals("��������") ||secondhand.get("RENT_ST").equals("��������")  ) && secondhand.get("RM_ST").equals("������")) {%>
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon.png align=absmiddle alt="�����" width="65" height="22">
						<img src=http://fms.amazoncar.co.kr/home/images/sub/sh_icon_dc.png align=absmiddle alt="������" width="65" height="22"><br/>
						<% if(!secondhand.get("RET_PLAN_DT").equals("")){%>�������Ό��:<%=AddUtil.ChangeDate5((String)secondhand.get("RET_PLAN_DT"))%><%}%>	

					<%} %>
				</span>
			</li>
		</ul>

		<% if(i == (secondhandList.size() - 1)) break;
			
		}
		}else{ %>
		<ul class="List">
			<li>
				<span>&nbsp;</span>     
				<span>����Ÿ�� �����ϴ�.</span>     				 									
			</li>
		</ul>
		<% } %>	

	</tbody>
</div> 
	
</div>
</form>
</body>
</html>
