<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*" %>
<%@ page import="acar.cont.*, acar.client.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>



<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String o_1 			= request.getParameter("o_1")==null?"":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_a 			= request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String amt 			= request.getParameter("amt")==null?"":request.getParameter("amt");
	
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_code 	= request.getParameter("est_code")==null?"":request.getParameter("est_code");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String mail_yn	= request.getParameter("mail_yn")	==null?"":request.getParameter("mail_yn");
	
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	UserMngDatabase 	umd = UserMngDatabase.getInstance();
	EstiDatabase 		e_db = EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb = AddCarMstDatabase.getInstance();
	
	
	
	//????????
	EstimateBean e_bean = new EstimateBean();
	
	//???? ????????
	Hashtable sh_comp = new Hashtable();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){		//FMS ?????????????????? ??????????/??????????
		e_bean 	= e_db.getEstimateCase(est_id);
		sh_comp = shDb.getShCompare(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}else{									//???????? ?????????? ??????
		e_bean 	= e_db.getEstimateShCase(est_id);
		sh_comp = shDb.getShCompareSh(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	opt_chk 	= e_bean.getOpt_chk();
	
	//????????
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//????????????
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);

	
	//????????
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String car_y_form		= String.valueOf(ht.get("CAR_Y_FORM"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 	= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 	= String.valueOf(ht.get("OPT"));
	String colo		 	= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));	
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String dist_cng			= String.valueOf(ht.get("DIST_CNG"));	
	int dpm 			= AddUtil.parseInt((String)ht.get("DPM"));
	float spe_dc_per		= AddUtil.parseFloat((String)ht.get("SPE_DC_PER"));
	String max_use_mon		= "48";
	
	String cha_st_dt 		= String.valueOf(ht.get("CHA_ST_DT"));
	String b_dist 			= String.valueOf(ht.get("B_DIST"));
	
	if(e_bean.getB_dist() > 0){
		cha_st_dt 		= e_bean.getCha_st_dt();
		b_dist 			= String.valueOf(e_bean.getB_dist());
	}
	
	//???????? ????????2(??????????2??????????)
	Hashtable carOld4 	= new Hashtable();
	if(!String.valueOf(ht.get("CAR_END_DT")).equals("") && AddUtil.checkDate(init_reg_dt)){		
		carOld4 = c_db.getOld(init_reg_dt, AddUtil.getDate(4), ""); //????
		int car_use_mon = (AddUtil.parseInt(String.valueOf(carOld4.get("YEAR")))*12) + AddUtil.parseInt(String.valueOf(carOld4.get("MONTH")));
		
		if(ej_bean.getJg_b().equals("2")){
			if(dpm > 2000){
				max_use_mon = String.valueOf(94-car_use_mon);
			}else{
				max_use_mon = String.valueOf(82-car_use_mon);
			}
		}else{
			if(dpm > 2000){
				max_use_mon = String.valueOf(95-car_use_mon);
			}else{
				max_use_mon = String.valueOf(83-car_use_mon);
			}
		}
	}
		
	if(AddUtil.parseInt(max_use_mon) > 48){
		max_use_mon = "48";
	}
	
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "????????????";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "????????????";
	
	//???? ????????
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();
	
	String rent_way = "2";
	if(!e_bean.getA_a().equals("")){
		a_a 		= "";
		if(e_bean.getA_a().length() > 1){		// ?????? ???? 2018.01.09
			e_bean.getA_a().substring(0,1);
			rent_way 	= e_bean.getA_a().substring(1);
		}
	}
	if(a_b.equals(""))	a_b	= e_bean.getA_b();
	String a_e 			= s_st;
	float o_13 			= 0;
	
	//????????
	String vali_date = "";
	
	if(e_bean.getReg_dt().length() < 9){	// ???????? ???? ?????? ???? ???? ????  2018.01.09
		System.out.println("##### error #####");
		System.out.println("est_id : "+e_bean.getEst_id());
		System.out.println("est_nm : "+e_bean.getEst_nm());
		System.out.println("reg_dt : "+e_bean.getReg_dt());
		System.out.println("########## end");
	}else {
		vali_date = AddUtil.getDate3(rs_db.addMonth(e_bean.getReg_dt().substring(0,8), 1));
	}
	
	//??????----------------------------------------------------------------
	
	String br_id 	= "S1";
	String name 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
		user_bean = umd.getUsersBean(e_bean.getReg_id());
	}else{
		if(!acar_id.equals("")){
			user_bean = umd.getUsersBean(acar_id);
		}
	}
	
	String client_st = "2";
	
	ContBaseBean base = new ContBaseBean();
	ClientBean client = new ClientBean();
	
		
		
		//????????????
		base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());
		
		// ???? ?????? ????
		String temp_first_rent_dt = a_db.getFirstRentDt(e_bean.getRent_mng_id());
		int first_rent_dt = Integer.parseInt(temp_first_rent_dt);
		
 		if(!e_bean.getEst_tel().equals("")){
			user_bean 	= umd.getUsersBean(e_bean.getEst_tel());
		}else{
			user_bean 	= umd.getUsersBean(base.getBus_id2());
		}
		
		//????????
		client = al_db.getClient(base.getClient_id());
		
		client_st = client.getClient_st();
		
		e_bean.setEst_tel(client.getO_tel());
		e_bean.setEst_email	(client.getCon_agnt_email());
		
		//????????????
		ContFeeBean fee = a_db.getContFeeNew(e_bean.getRent_mng_id(), e_bean.getRent_l_cd(), Integer.toString(AddUtil.parseInt(e_bean.getRent_st())-1));
		
		// ???? ???? ????
		ContCarBean before_fee_etc = a_db.getContFeeEtc(e_bean.getRent_mng_id(), e_bean.getRent_l_cd(), Integer.toString(AddUtil.parseInt(e_bean.getRent_st())-1));
		

	
	name 		= user_bean.getUser_nm();
	m_tel 		= user_bean.getUser_m_tel();
	br_id   	= user_bean.getBr_id();
	h_tel 		= user_bean.getHot_tel();
	i_fax   	= user_bean.getI_fax();
	email 		= user_bean.getUser_email();

	if(name.equals("??????")) name = "??????";
	
	if(user_bean.getDept_id().equals("1000") && e_bean.getEst_st().equals("2")){
		vali_date = "?????? ????";
	}	

%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="euc-kr">
<title>??????</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(????????????)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(????????????)");
	}
})
</script>
<style type="text/css">
<!--

.style1 {
	color: #000000;
	font-weight: bold;
	font-size: 22px;
}
.style2 {
	color: #000000;
	font-weight: bold;
}
.style3 {
	color: #000000;
}
.style4 {color: #000000;}
.style5 {color: #000000;}
.style7 {color: #000000; font-weight: bold;}
.style8 {color: #000000; font-weight: bold; font-size:30px;}
.style9 {color: #000000;}
.style12 {color: #000000; font-weight: bold;}
.style13 {
	color: #000000;

}
.style14 {color: #000000; font-weight: bold;}
.style15 {
	color: #000000;
	font-weight: bold;
	font-size: 8pt}
.style16 {
	color: #000000;
	font-size: 11px;
}
-->
</style>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin???? ?????? ???? ???? */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*????*/
		-webkit-margin-end: 0mm; /*????*/
		-webkit-margin-after: 0mm; /*????*/
		-webkit-margin-start: 0mm; /*????*/
}

</style>
<link href="/acar/main_car_hp/style_est_comp.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
</head>
<body topmargin=0 leftmargin=0 <%if(mail_yn.equals("")){%>onLoad="javascript:onprint();"<%}%>>
<%if(mail_yn.equals("")){%>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%}%>
<form action="" name="form1" method="POST" >
<input type="hidden" name="est_id" value="<%=est_id%>">
<table width=680 border=0 cellspacing=0 cellpadding=0>
    <tr bgcolor=80972e>
        <td height=3 colspan=3></td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=16>&nbsp;</td>
                    <td width=448 align=right style="padding-right:25px;"><span class=style8>???????? ???????? ??????</span></td>
                    <td width=195 align=right>
                        <table width=100% border=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr>
                                <td width=48 bgcolor=f2f2f2 height=15 align=center><span class=style16>??????</span></td>
                                <td width=139 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getReg_dt())%></span></td>
                            </tr>
							              <%      String rent_end_dt="";
										                rent_end_dt = c_db.addMonth(e_bean.getRent_dt(), AddUtil.parseInt(e_bean.getA_b()));
										                rent_end_dt = c_db.addDay(rent_end_dt, -1);%>
                            <tr>
                                <td bgcolor=f2f2f2 height=15 align=center><span class=style16>????????</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%>~<br><%=AddUtil.getDate3(rent_end_dt)%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=15><span class=style16>????????</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=21>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=638>
            <table width=638 border=0 cellspacing=0 cellpadding=0>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellspacing=0 cellpadding=0>
                <tr> 
                  <td width=410> <table width=410 border=0 cellspacing=0 cellpadding=0>
                      <tr> 
                        <td height=30 colspan=4>&nbsp;<span class=style1>[ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> ] - ????????</span></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                      <tr> 
                        <td width=24 height=25 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=180><div align="left"><span class=style3><%=e_bean.getEst_nm()%>??
                            <%if(client_st.equals("2")){%>????<%}else{%>????<%}%></span></div></td>
                        <td width=24 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td width=182><div align="left"><span class=style3><%=AddUtil.ChangeDate2(e_bean.getRent_dt())%></span></div></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                      <tr> 
                        <td height=25 align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style3>TEL.<%=e_bean.getEst_tel()%></span></td>
                        <td align=center><img src=/acar/main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        <td><span class=style3>FAX.<%=e_bean.getEst_fax()%></span></td>
                      </tr>
                      <tr> 
                        <td colspan=4><img src=/acar/main_car_hp/images/line.gif width=409 height=1></td>
                      </tr>
                    </table></td>
                  <td width=28>&nbsp;</td>
                  <td width=201 valign=bottom>
                  	<table width=201 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_new.gif  height=76>
		      			<tr> 
                        	<td colspan=4 height=7></td>
	                      </tr>
	                      <tr> 
	                        <td width=60 align=center>&nbsp;<span class=style5><b><%= name %></b></span></td>
	                        <td width=30 align=right><span class=style5>hp)</span></td>
	                        <td width=111 class=listnum2>&nbsp;<span class=style5><%= m_tel %></span></td>
	                      </tr>
	                     	<tr> 
	                        <td>&nbsp;</td>
	                        <td align=right><span class=style5>tel)</span></td>
	                        <td class=listnum2>&nbsp;<span class=style5><%= h_tel %></span></td>
	                      </tr>
	                     	<tr> 
	                     	<td>&nbsp;</td>
	                        <td align=right><span class=style5>fax)</span></td>
	                        <td class=listnum2>&nbsp;<span class=style5><%= i_fax %></span></td>
	                      </tr>
	                    	<tr> 
	                        <td>&nbsp;</td>
	                        <td colspan='2' valign=top>&nbsp;&nbsp;<span class=style5><%= email %></span></td>
	                      </tr>
           	      		<tr> 
                        <td colspan=4 height=2></td>
                      </tr>          
                    </table> 
					</td>
                </tr>
				<%if(stat.equals("????????????")){%>
                <tr> 
                  <td colspan="3" height="12">&nbsp;?? ?? ?????? ?????? ????????????, ?????????? ?????????? ?????????? ??????????.</td>
                </tr>
				<%}	else if(stat.equals("????????????")){%>
                <tr> 
                  <td colspan="3" height="12">&nbsp;?? ?? ?????? ?????? ????????????, ???????????? ???????????? ?????????? ??????????.</td>                
				</tr>
				<%}else{%>
                <tr> 
                  <td colspan="3" height="5"></td>
                </tr>
				<%}%>				
              </table></td>
          </tr>
          <tr> 
            <td height=2 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"><%if(e_bean.getAccid_serv_zero().equals("Y")){//????????????%><img src=../main_car_hp/images/bar_01_msg_2014.gif><%}else{%><img src=../main_car_hp/images/bar_01_2014.gif><%}%></td>
          </tr>
          <tr> 
            <td height=2 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=132 height=15 align=center bgcolor=f2f2f2><span class=style3>??????</span></td>
                  <td width=358 bgcolor=#FFFFFF>&nbsp;<span class=style3><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
                  <td width=144 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ??</span></td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>????(??????????)</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%=car_name%></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style4><%if(stat.equals("????????????")){%>??????<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>
                    ??<%}%></span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ??</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%=opt%></span>
                      <%if(car_mng_id.equals("018647")){%>(???? ???????? ???????? ?????? ?????? ??????)<%}%>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(opt_amt) %>
                    ??</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ?? </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3><b><%if(!e_bean.getIn_col().equals("")){%>????: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;????: <%=e_bean.getIn_col()%><%}%></b></span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%= AddUtil.parseDecimal(clr_amt) %>
                    ??</span>&nbsp;</td>
                </tr>
                <%if(!e_bean.getConti_rat().equals("")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ?? </span></td>
                  	<td bgcolor=#FFFFFF>
                  		<span id="contiRatDesc">&nbsp;<%=e_bean.getConti_rat()%></span>
                  	</td>
					<td bgcolor=#FFFFFF>&nbsp;</td>
                </tr>
                <%}%>
                <!-- ???? ?????? ???? ????(2017.10.13) -->
                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr>
                	<td height=15 align=center bgcolor=f2f2f2><span class=style3>???? ?????? ???? </span></td>
                    <td bgcolor=#FFFFFF>
                    </td>
                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> ??</span>&nbsp;</td>
                </tr>
                <%}%>
                
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>????????
                   </span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>?????????? : <%=AddUtil.ChangeDate2(init_reg_dt)%> (????????:<%=car_y_form%>)
                  		&nbsp;&nbsp;???????? : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
                  	</span>
                  </td>
                  <td align=right bgcolor=#FFFFFF><span class=style3>-<%if(stat.equals("????????????") || stat.equals("????????????")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%>
				    ??</span>&nbsp;</td>
                </tr>
                <tr> 
                  <td height=15 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;<span class=style3>???????? : <%if(!car_no.equals("")&&car_no.length()>3){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %>
                      </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style7><%if(stat.equals("????????????")){%>??????<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%>
                    ??<%}%></span>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
		 	<td height=10 colspan="2">
		   		<table width=638 border=0 cellpadding=0 cellspacing=1>
		        	<tr>
		          		<td>&nbsp;</td>
			            <td height=10 align="right"><span class=style3>
						<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//????????????,????%>
									?? LPG/?????? ??????
						<%}else{%>						
						<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		* ????????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	* LPG??????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	* ??????????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	?? ??????????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	?? ???????? ??????????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	?? ??????
						<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	?? ??????
						<%	}else{%>
							<%if(cm_bean.getDiesel_yn().equals("Y")){%>			* ????????
							<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		* LPG??????
							<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		* ??????????
							<%}else if(cm_bean.getDiesel_yn().equals("3")){%>		?? ??????????
							<%}else if(cm_bean.getDiesel_yn().equals("4")){%>		?? ???????? ??????????
							<%}else if(cm_bean.getDiesel_yn().equals("5")){%>		?? ??????
							<%}else if(cm_bean.getDiesel_yn().equals("6")){%>		?? ??????
							<%}%>
						<%	}%>
						<%}%>&nbsp;</span>			
						</td>
			          </tr>
			      </table>
			  </td>
			</tr>
          <%if(!dist_cng.equals("")){%>
          <tr>
          	<td colspan="2" bgcolor=f2f2f2 height=40> &nbsp;<span class=style3> * ?? ?????? ?????? ???? ????(<%=AddUtil.getDate3(cha_st_dt)%>)?? ???? ???????? ?????? ?????? ?????????? <%=AddUtil.parseDecimal(b_dist)%>km, ??????<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;?? ???????? ?????????? <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km??????. ???????? ?????????? ?????????? <%=AddUtil.parseDecimal(today_dist)%>km?? ????????, ??????????<br>
          	&nbsp;&nbsp;&nbsp;&nbsp;???? ?????????? ??????????????.</span></td>
          </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <%}%> 
		  
          
         
	<!-- ????????-->
					<tr> 
	               		<td colspan="2">
	                        <div style="position: relative;">
								<img src=../main_car_hp/images/bar_02_ins.gif align=left>
								<span style="position: absolute; top:4; right:4;">
									<%if (client_st.equals("1")) {%>
										<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && e_bean.getCom_emp_yn().equals("Y")) {%>
			                        	      ?? ?????????? : ??????????
			                        	<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && e_bean.getCom_emp_yn().equals("Y")) {%>
		                        	  	    ?? ?????????? : ??????????      
		                        		<%} else {%>    
			                        	     ?? ?????????? : ???????? ????????                        	  
			                        	<%}%>
			                        <%} else if (client_st.equals("2")) {%>
			                        	  ?? ?????????? : ???????? ????????
			                        <%} else if (client_st.equals("3")) {%>
			                        	  ?? ?????????? : ?????? ?? ????????
			                        <%}%>
								</span>
							</div>
		            	</td>
					</tr>
					<tr> 
						<td height=2 colspan=3></td>
					</tr>
					<tr>
						<td colspan="2">
							<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
								<tr>
									<td height=17 align=center bgcolor=f2f2f2>????????</td>
									<td align=center bgcolor=f2f2f2>????????</td>
									<td align=center bgcolor=f2f2f2>????????????</td>
									<td align=center bgcolor=f2f2f2>??????????</td>
									<td align=center bgcolor=f2f2f2>????????????</td>
									<td align=center bgcolor=f2f2f2>??????????</td>
									<td align=center bgcolor=f2f2f2>????????</td>
								</tr>
						<%if(!e_bean.getIns_per().equals("2")){%>
								<tr>
									<td height=17 align=center bgcolor=#FFFFFF>????(??????,??)</td>
									<td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5??????<%}else if(e_bean.getIns_dj().equals("4")){%>2????<%}else if(e_bean.getIns_dj().equals("8")){%>3????<%}else if(e_bean.getIns_dj().equals("3")){%>5????<%}else{%>1????<%}%></span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5??????<%}else{%>1????<%}%></span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>??</span></td>
									<td align=center bgcolor=#FFFFFF>1???? ???? 2????</td>
									<td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_age().equals("2")){%>??21??????<%}else if(e_bean.getIns_age().equals("3")){%>??24??????<%}else{%>??26??????<%}%></span></td>
									<td align=center bgcolor=#FFFFFF>?? ??</td>
								</tr>
							<%}else{%>
								<tr>
									<td height=17 align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
									<td align=center bgcolor=#FFFFFF>??????????</td>
									<td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
									<td align=center bgcolor=#FFFFFF><span class=style4>??????????</span></td>
								</tr>
							<%}%>	
							</table>
						</td>
					</tr>
					
					<%-- <%if (AddUtil.parseInt(e_bean.getCar_comp_id()) > 5 && e_bean.getA_a().equals("12")) {%>
		            <tr>
						<td colspan="2" align="right">?? ?????????? ???????? ???? ???????????? ????</td>
		            </tr>
		            <%}%> --%>
					
					<tr> 
						<td height=5 colspan="2"></td>
					</tr>
					<tr> 
						<td colspan="2"> 
						<table width=638 border=0 cellspacing=0 cellpadding=0>
							<%if(first_rent_dt < 20220415){ 	// ???? ???????? 2022?? 4?? 14???????? ???? ???? ????%>
							<tr> 
							  <td>
							  	<table width=638 border=0 cellspacing=0 cellpadding=0>
							  		<tr>
							  			<td>
										  	<%-- <%if(!e_bean.getIns_per().equals("2")){%><img src=/acar/main_car_hp/images/bar_03_fee_ins.gif ><%}else{%><img src=/acar/main_car_hp/images/bar_03_fee_nins.gif><%}%> --%>
										  	<%if(!e_bean.getIns_per().equals("2")){%><img src=/acar/main_car_hp/images/bar_03_fee_ins.gif ><%}else{%><img src=/acar/main_car_hp/images/bar_03_fee.png><%}%>
							  			</td>
							  			<td align="right">
											<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %><span>?? ?????????? = (?????? ?? ????????) + ????????</span><%} %>
							  			</td>
							  		</tr>
							  	</table>
							  </td>
							</tr>
							<tr> 
							  <td height=2 colspan=3></td>
							</tr>
							<tr> 
								<td>
								<%if(!e_bean.getIns_per().equals("2")){%> 
									<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
										<tr>
											<td rowspan="2" bgcolor=f2f2f2>&nbsp;</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center><span class=style7>??????????</span></td>
											<td height=17 colspan="2" bgcolor=f2f2f2 align=center>???? ?????? ????</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center>???? ??????</td>
										</tr>
										<tr>
											<td bgcolor=f2f2f2 align=center>????????</td>
											<td bgcolor=f2f2f2 align=center>??????</td>
										</tr>
										<tr>
											<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
											<td width=135 align=right bgcolor=#FFFFFF><span class=style7><%=e_bean.getA_b()%>????</span>&nbsp;</td>
											<td width=135 align=right bgcolor=#FFFFF>&nbsp;</td>
											<td width=135 align=center bgcolor=#FFFFF>&nbsp;</td>
											<td width=135 align=right bgcolor=#FFFFF><%=fee.getCon_mon()%>????&nbsp;</td>
										</tr>
									  <%	int fee_s_amt = e_bean.getFee_s_amt();
											int fee_v_amt = e_bean.getFee_v_amt();
											int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
											
											//2018.04.09 ???? ?????????????? ?????????????? ???? ????(20180608)
											if(e_bean.getEst_st().equals("2") && !e_bean.getReg_dt().equals("") && e_bean.getReg_dt().length() > 7 &&AddUtil.parseInt(e_bean.getReg_dt().substring(0,8)) >= 20180409 && e_bean.getDriver_add_amt() > 0){
												fee_t_amt = (int)Math.round((double)((e_bean.getFee_s_amt() + e_bean.getDriver_add_amt())*1.1));
												fee_s_amt = e_bean.getFee_s_amt() + e_bean.getDriver_add_amt();
												fee_v_amt = fee_t_amt - fee_s_amt;
											}
											
											//int cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
											//int cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
											//?????? ???? ?????????? ?????????? ????????(20190909)
											int cal_s_amt = 0;
											int cal_v_amt = 0;
											
											if(!fee.getCon_mon().equals("")){
												cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
												cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
											}
									  %>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_s_amt)%> ??</span>&nbsp;</td><!--??????????-->
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt-fee_s_amt)%>??&nbsp;</td><!--????????-->
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt)%>??&nbsp;</td><!--??????????-->
										<%}else{ %>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()-fee_s_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_v_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<%
											float cal1=0, cal2=0;
											if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt;
										  	}else{		
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt();
										  	}		
											float dc_per = cal1/cal2*100;
										%>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_t_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFF><%=AddUtil.calcMath("ROUND", String.valueOf(dc_per), 1)%>%</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFF><%=AddUtil.calcMath("ROUND", String.valueOf(dc_per), 1)%>%</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
									</table>
								<%}else{	//?????? ?????????? view ????(20190710)%>
									<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
										<tr>
											<td rowspan="2" bgcolor=f2f2f2>&nbsp;</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center><span class=style7>??????????</span><br>(????????????)</td>
											<td height=17 colspan="2" bgcolor=f2f2f2 align=center>&nbsp;</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center>???? ??????<br>(??????????)</td>
										</tr>
										<tr>
											<td bgcolor=f2f2f2 align=center>&nbsp;</td>
											<td bgcolor=f2f2f2 align=center>&nbsp;</td>
										</tr>
										<tr>
											<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
											<td width=135 align=right bgcolor=#FFFFFF><span class=style7><%=e_bean.getA_b()%>????</span>&nbsp;</td>
											<td width=135 align=right bgcolor=#FFFFF>&nbsp;</td>
											<td width=135 align=center bgcolor=#FFFFF>&nbsp;</td>
											<td width=135 align=right bgcolor=#FFFFF><%=fee.getCon_mon()%>????&nbsp;</td>
										</tr>
									  <%	int fee_s_amt = e_bean.getFee_s_amt();
											int fee_v_amt = e_bean.getFee_v_amt();
											int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
											
											//2018.04.09 ???? ?????????????? ?????????????? ???? ????(20180608)
											if(e_bean.getEst_st().equals("2") && !e_bean.getReg_dt().equals("") && e_bean.getReg_dt().length() > 7 &&AddUtil.parseInt(e_bean.getReg_dt().substring(0,8)) >= 20180409 && e_bean.getDriver_add_amt() > 0){
												fee_t_amt = (int)Math.round((double)((e_bean.getFee_s_amt() + e_bean.getDriver_add_amt())*1.1));
												fee_s_amt = e_bean.getFee_s_amt() + e_bean.getDriver_add_amt();
												fee_v_amt = fee_t_amt - fee_s_amt;
											}
											
											int cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
											int cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
									  %>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_s_amt)%> ??</span>&nbsp;</td><!--??????????-->
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>
											<td align=right bgcolor=#FFFFF>&nbsp;</td><!--????????-->
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt)%>??&nbsp;</td><!--??????????-->
										<%}else{ %>
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_v_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<%
											float cal1=0, cal2=0;
											if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt;
										  	}else{		
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt();
										  	}		
											float dc_per = cal1/cal2*100;
										%>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>????????</span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_t_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
									</table>
									<%}%>
								</td>						
							</tr>
									                
							<%} else{ // ???? ?????? 2022?? 4?? 15?? ?????? ???? ???? ???? %>
							<tr> 
							  <td>
							  	<table width=638 border=0 cellspacing=0 cellpadding=0>
							  		<tr>
							  			<td>
										  	<%-- <%if(!e_bean.getIns_per().equals("2")){%><img src=/acar/main_car_hp/images/bar_03_fee_ins.gif ><%}else{%><img src=/acar/main_car_hp/images/bar_03_fee_nins.gif><%}%> --%>
										  	<%if(!e_bean.getIns_per().equals("2")){%>
										  		<img src=/acar/main_car_hp/images/bar_2022_03_yj.jpg>
										  	<%}else{%>
										  		<img src=/acar/main_car_hp/images/bar_2022_03_yj_1.jpg>
										  	<%}%>
							  			</td>
							  			<td align="right">
											<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %><span>?? ?????????? = (?????? ?? ????????) + ????????</span><%} %>
							  			</td>
							  		</tr>
							  	</table>
							  </td>
							</tr>
							<tr> 
							  <td height=2 colspan=3></td>
							</tr>
							<tr> 
								<td>
								<%if(!e_bean.getIns_per().equals("2")){%> 
									<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
										<colgroup>
											<col width="100px;"/>
											<col width="100px;"/>
										</colgroup>
										<tr>
											<td rowspan="2" colspan='2' bgcolor=f2f2f2 align=center>&nbsp;????</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center><span class=style7>????????</span></td>
											<td height=17 colspan="2" bgcolor=f2f2f2 align=center>???? ?????? ????</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center>???? ????</td>
										</tr>
										<tr>
											<td bgcolor=f2f2f2 align=center>????????</td>
											<td bgcolor=f2f2f2 align=center>??????</td>
										</tr>
										<tr>
											<td width=92 height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>????????</span></td>
											<td width=155 align=right bgcolor=#FFFFFF><span class=style7><%=e_bean.getA_b()%>????</span>&nbsp;</td>
											<td width=115 align=right bgcolor=#FFFFF>&nbsp;</td>
											<td width=115 align=center bgcolor=#FFFFF>&nbsp;</td>
											<td width=155 align=right bgcolor=#FFFFF><%=fee.getCon_mon()%>????&nbsp;</td>
										</tr>
									  <%	int fee_s_amt = e_bean.getFee_s_amt();
											int fee_v_amt = e_bean.getFee_v_amt();
											int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
											
											//2018.04.09 ???? ?????????????? ?????????????? ???? ????(20180608)
											if(e_bean.getEst_st().equals("2") && !e_bean.getReg_dt().equals("") && e_bean.getReg_dt().length() > 7 &&AddUtil.parseInt(e_bean.getReg_dt().substring(0,8)) >= 20180409 && e_bean.getDriver_add_amt() > 0){
												fee_t_amt = (int)Math.round((double)((e_bean.getFee_s_amt() + e_bean.getDriver_add_amt())*1.1));
												fee_s_amt = e_bean.getFee_s_amt() + e_bean.getDriver_add_amt();
												fee_v_amt = fee_t_amt - fee_s_amt;
											}
											
											//int cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
											//int cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
											//?????? ???? ?????????? ?????????? ????????(20190909)
											int cal_s_amt = 0;
											int cal_v_amt = 0;
											
											if(!fee.getCon_mon().equals("")){
												cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
												cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
											}
									  %>
										<tr> 
											<td width=92 height=17 align=center bgcolor=f2f2f2 rowspan='3'><span class=style3>????????</span></td>
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_s_amt)%> ??</span>&nbsp;</td><!--??????????-->
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt-fee_s_amt)%>??&nbsp;</td><!--????????-->
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt)%>??&nbsp;</td><!--??????????-->
										<%}else{ %>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()-fee_s_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_v_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<%
											float cal1=0, cal2=0;
											if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt;
										  	}else{		
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt();
										  	}		
											float dc_per = cal1/cal2*100;
										%>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>????</span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_t_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFF><%=AddUtil.calcMath("ROUND", String.valueOf(dc_per), 1)%>%</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt)%>??&nbsp;</td>
											<td align=center bgcolor=#FFFFF><%=AddUtil.calcMath("ROUND", String.valueOf(dc_per), 1)%>%</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 rowspan='2' colspan='2'><span class=style3>????????????</span></td>
											<td align=right bgcolor=#FFFFFF><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km????/1??&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF><%=AddUtil.parseDecimal(before_fee_etc.getAgree_dist())%>km????/1??&nbsp;</td>
										</tr>
										<tr> 
											<td align=right bgcolor=#FFFFFF>
											<%
												if(Integer.parseInt(e_bean.getA_b()) < 12){ 
												double cur_agree_dist = Double.parseDouble(String.valueOf(e_bean.getAgree_dist()));
												double cur_a_b = Double.parseDouble(e_bean.getA_b());
											%>
												?? <%=AddUtil.parseDecimal(String.valueOf(Math.round(cur_agree_dist/12*cur_a_b)))%>km????/<%=e_bean.getA_b()%>????&nbsp;
											<%} %>
											</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF>
											<%
												if(Integer.parseInt(fee.getCon_mon()) < 12){ 
												double before_agree_dist = Double.parseDouble(String.valueOf(before_fee_etc.getAgree_dist()));
												double before_a_b = Double.parseDouble(fee.getCon_mon());
											%>
												?? <%=AddUtil.parseDecimal(String.valueOf(Math.round(before_agree_dist/12*before_a_b)))%>km????/<%=fee.getCon_mon()%>????&nbsp;
											<%} %>
											</td>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>(??????????????) ??????????</span></td>
											<td align=right bgcolor=#FFFFFF>
											<%if(e_bean.getRtn_run_amt_yn().equals("1")){ // ?????????? ??????%>
												<b>??????</b>
		            			  			<%} else{%>
												<b><%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>??/1km</b>&nbsp;(?????? ????)
		            			  			<%} %>
											</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF>
											<%if(before_fee_etc.getRtn_run_amt_yn().equals("1")){  // ?????????? ??????%>
												<b>??????</b>
											<%} else{ %>
												<b><%=AddUtil.parseDecimal(before_fee_etc.getRtn_run_amt())%>??/1km</b>&nbsp;(?????? ????)
											<%} %>
											</td>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>(??????????????) ??????????????</span></td>
											<td align=right bgcolor=#FFFFFF><b><%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>??/1km</b>&nbsp;(?????? ????)</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF><b><%=AddUtil.parseDecimal(before_fee_etc.getOver_run_amt())%>??/1km</b>&nbsp;(?????? ????)</td>
										</tr>
										<tr>
											<td bgcolor=#FFFFF colspan=6>
											&nbsp; ?? ???????? ?????? ???? ?????????? ?????????????? ?????????? ?????????????? ???????? ???? ?????????? ?????????? ???? ?????????????? ??????????.<br>
											&nbsp; ?? ?????????? ?????????????? ???? ?????? ???? ?????? ?????? <b>??????????(<%if(e_bean.getRtn_run_amt() != 0){%><%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%><%}else{ %> ?????? <%} %>??/1km,??????????) ?? ??????????????(<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>??/1km,??????????)</b>?? ??????.<br>
											<%if(e_bean.getA_a().equals("12")||e_bean.getA_a().equals("22")){	// ??????%>
												&nbsp; ?? ???????? ?????????? (??????????????) ???????????? ???????? ????, (??????????????) ???????????????? ??????????. (??????)
											<%}%>
											</td>
										</tr>
									</table>
								<%}else{	//?????? ?????????? view ????(20190710)%>
									<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
										<colgroup>
											<col width="100px;"/>
											<col width="100px;"/>
										</colgroup>
										<tr>
											<td rowspan="2" colspan='2' bgcolor=f2f2f2 align=center >&nbsp;????</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center><span class=style7>????????</span><br>(????????????)</td>
											<td height=17 colspan="2" bgcolor=f2f2f2 align=center>&nbsp;</td>
											<td rowspan="2" bgcolor=f2f2f2 align=center>???? ??????<br>(??????????)</td>
										</tr>
										<tr>
											<td bgcolor=f2f2f2 align=center>&nbsp;</td>
											<td bgcolor=f2f2f2 align=center>&nbsp;</td>
										</tr>
										<tr>
											<td width=92 height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>????????</span></td>
											<td width=155 align=right bgcolor=#FFFFFF><span class=style7><%=e_bean.getA_b()%>????</span>&nbsp;</td>
											<td width=115 align=right bgcolor=#FFFFF>&nbsp;</td>
											<td width=115 align=center bgcolor=#FFFFF>&nbsp;</td>
											<td width=155 align=right bgcolor=#FFFFF><%=fee.getCon_mon()%>????&nbsp;</td>
										</tr>
									  <%	int fee_s_amt = e_bean.getFee_s_amt();
											int fee_v_amt = e_bean.getFee_v_amt();
											int fee_t_amt = e_bean.getFee_s_amt()+e_bean.getFee_v_amt();
											
											//2018.04.09 ???? ?????????????? ?????????????? ???? ????(20180608)
											if(e_bean.getEst_st().equals("2") && !e_bean.getReg_dt().equals("") && e_bean.getReg_dt().length() > 7 &&AddUtil.parseInt(e_bean.getReg_dt().substring(0,8)) >= 20180409 && e_bean.getDriver_add_amt() > 0){
												fee_t_amt = (int)Math.round((double)((e_bean.getFee_s_amt() + e_bean.getDriver_add_amt())*1.1));
												fee_s_amt = e_bean.getFee_s_amt() + e_bean.getDriver_add_amt();
												fee_v_amt = fee_t_amt - fee_s_amt;
											}
											
											int cal_s_amt = fee.getPp_s_amt() / AddUtil.parseInt(fee.getCon_mon());
											int cal_v_amt = fee.getPp_v_amt() / AddUtil.parseInt(fee.getCon_mon());
									  %>
										<tr> 
											<td width=92 height=17 align=center bgcolor=f2f2f2 rowspan='3'><span class=style3>????????</span></td>
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_s_amt)%> ??</span>&nbsp;</td><!--??????????-->
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>
											<td align=right bgcolor=#FFFFF>&nbsp;</td><!--????????-->
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+cal_s_amt)%>??&nbsp;</td><!--??????????-->
										<%}else{ %>
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>?? ?? ?? </span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_v_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt()+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFFr>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<%
											float cal1=0, cal2=0;
											if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt-fee_s_amt-fee_v_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt;
										  	}else{		
												//dc_per = AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt))/AddUtil.parseFloat(String.valueOf(fee.getFee_s_amt()+fee.getFee_v_amt()))*100;
												cal1 = fee.getFee_s_amt()+fee.getFee_v_amt()-fee_t_amt;
												cal2 = fee.getFee_s_amt()+fee.getFee_v_amt();
										  	}		
											float dc_per = cal1/cal2*100;
										%>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2><span class=style3>????</span></td>
											<td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(fee_t_amt)%> ??</span>&nbsp;</td>
										<%if((fee.getPp_s_amt()+fee.getPp_v_amt()) > 0){ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt()+cal_s_amt+cal_v_amt)%>??&nbsp;</td>
										<%}else{ %>	
											<td align=right bgcolor=#FFFFF>&nbsp;</td>
											<td align=center bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFF><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>??&nbsp;</td>
										<%} %>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 rowspan='2' colspan='2'><span class=style3>????????????</span></td>
											<td align=right bgcolor=#FFFFFF><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km????/1??&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF><%=AddUtil.parseDecimal(before_fee_etc.getAgree_dist())%>km????/1??&nbsp;</td>
										</tr>
										<tr> 
											<td align=right bgcolor=#FFFFFF>
											<%if(Integer.parseInt(e_bean.getA_b()) < 12){ 
												double cur_agree_dist = Double.parseDouble(String.valueOf(e_bean.getAgree_dist()));
												double cur_a_b = Double.parseDouble(e_bean.getA_b());
											%>
												?? <%=AddUtil.parseDecimal(String.valueOf(Math.round(cur_agree_dist/12*cur_a_b)))%>km????/<%=e_bean.getA_b()%>????&nbsp;
											<%} %>
											</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF>
											<%if(Integer.parseInt(fee.getCon_mon()) < 12){ 
												double before_agree_dist = Double.parseDouble(String.valueOf(before_fee_etc.getAgree_dist()));
												double before_a_b = Double.parseDouble(fee.getCon_mon());
											%>
												?? <%=AddUtil.parseDecimal(String.valueOf(Math.round(before_agree_dist/12*before_a_b)))%>km????/<%=fee.getCon_mon()%>????&nbsp;
											<%} %>
											</td>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>(??????????????) ??????????</span></td>
											<td align=right bgcolor=#FFFFFF>
											<%if(e_bean.getRtn_run_amt() != 0){ %>
												<b><%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>??/1km</b>&nbsp;(?????? ????)
											<%} else{ %>
												<b>??????</b>
											<%} %>
											</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF>
											<%if(before_fee_etc.getRtn_run_amt() != 0){ %>
											<b><%=AddUtil.parseDecimal(before_fee_etc.getRtn_run_amt())%>??/1km</b>&nbsp;(?????? ????)
											<%} else{ %>
											<b>??????</b>
											<%} %>
											</td>
										</tr>
										<tr> 
											<td height=17 align=center bgcolor=f2f2f2 colspan='2'><span class=style3>(??????????????) ??????????????</span></td>
											<td align=right bgcolor=#FFFFFF><b><%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>??/1km</b>&nbsp;(?????? ????)</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td bgcolor=#FFFFF>&nbsp;</td>
											<td align=right bgcolor=#FFFFFF><b><%=AddUtil.parseDecimal(before_fee_etc.getOver_run_amt())%>??/1km</b>&nbsp;(?????? ????)</td>
										</tr>
										<tr>
											<td bgcolor=#FFFFF colspan=6>
											&nbsp; ?? ???????? ???? ?? ???? ?????????? ?????????????? ?????????? ?????????????? ???????? ???? ?????????? ?????????? ???? ?????????????? ??????????.<br>
											&nbsp; ?? ?????????? ?????????????? ???? ?????? ???? ?????? ?????? <b>??????????(<%if(e_bean.getRtn_run_amt() != 0){%><%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%><%}else{ %> ?????? <%} %>??/1km,??????????) ?? ??????????????(<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>??/1km,??????????)</b>?? ??????.<br>
											<%if(e_bean.getA_a().equals("12")||e_bean.getA_a().equals("22")){	// ??????%>
												&nbsp; ?? ???????? ?????????? (??????????????) ???????????? ???????? ????, (??????????????) ???????????????? ??????????. (??????)
											<%}%>
											</td>
										</tr>
									</table>
									<%}%>
								</td>						
							</tr>	
							<%} %>	                
 	<!-- ????????-->               
        		<!--????-->
        		<%if(e_bean.getTint_b_yn().equals("Y") || e_bean.getTint_s_yn().equals("Y")|| e_bean.getTint_n_yn().equals("Y")|| e_bean.getTint_eb_yn().equals("Y")){
        				String tint_all = "";
        				if(e_bean.getTint_b_yn().equals("Y")){	tint_all +="1";	}		//2???? ????????
        				if(e_bean.getTint_s_yn().equals("Y")){	tint_all +="2";	}		//???? ????
        				if(e_bean.getTint_n_yn().equals("Y")){	tint_all +="3";	}		//?????? ??????????
        				if(e_bean.getTint_eb_yn().equals("Y")){	tint_all +="4";	}		//?????? ?????? ????????
        		%>                        
                        <tr> 
			    			<td colspan=3 class=listnum2 valign=top>&nbsp;<span class=style3>* 
                                <%if(tint_all.equals("1")){%>?? ?????????? 2???? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("2")){%>?? ?????????? ???? ?????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("3")){%>?? ?????????? ?????? ???????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("4")){%>?? ?????????? ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("12")){%>?? ?????????? 2???? ?????????? ???? ?????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("13")){%>?? ?????????? 2???? ?????????? ?????? ???????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("14")){%>?? ?????????? 2???? ?????????? ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("23")){%>?? ?????????? ???? ?????? ?????? ???????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("24")){%>?? ?????????? ???? ?????? ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("34")){%>?? ?????????? ?????? ???????????? ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("123")){%>?? ?????????? 2???? ????????, ???? ????, ?????? ???????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("124")){%>?? ?????????? 2???? ????????, ???? ????, ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("134")){%>?? ?????????? 2???? ????????, ?????? ??????????, ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("234")){%>?? ?????????? ???? ????, ?????? ??????????, ?????? ?????? ?????????? ?????? ??????????.<%}%>
                            	<%if(tint_all.equals("1234")){%>?? ?????????? 2???? ????????, ???? ????, ?????? ??????????, ?????? ?????? ?????????? ?????? ??????????.<%}%>    
                             	</span>
                            </td>
                        </tr>                        
                        <%}%>                               
                
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>

                <tr> 
					<td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* ??????(????????,??????)?? ?????????? ???????? ?????? ???? ???????? <strong>????????????(????)?????? ?? ????????.</strong>
					</span></td>
                </tr>
				<%}%>	
				<%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>

                <tr> 
					<td height=15 colspan=3 class=listnum2>&nbsp;<span class=style3>* ??????(????????,??????)?? ?????????? ???????? ?????? ???? ???????? <strong>????????????(????)?????? ?? ????????.</strong>
					</span></td>
                </tr>
				<%}%>
				

              </table>
              </td>
          </tr>
          <tr> 
             <td height=5 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"><img src=/acar/main_car_hp/images/bar_04_2014.gif></td>
          </tr>
          <tr> 
            <td height=2 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> 
            <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=82 height=13 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ?? ??</span></td>
                  <td width=93 align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getGtr_amt())%> 
                    ??</span>&nbsp;</td>
                  <td width=65 align=center bgcolor=f2f2f2><span class=style3></span></td>
                  <td width=393 bgcolor=#FFFFFF>&nbsp;<span class=style3>???????? 
			  	???????? ???? ?? ?????? ????????.</span></td>
				</tr>
                <tr> 
                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ?? ??</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%> 
				    ??</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style4>VAT????</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ???????????? ????????X(2018.03.29) -->
                  	<span class=style3>???????? ???? ???? ?????? ???????? ???????? ????????. </span><br>&nbsp;
                  	<span class="style3" style="letter-spacing:-0.7px;">?? ???????????? ???????????? ???? ???? ???? ???? ???? ?????? ???? ???? ?? ???????? </span>
                  	<%} %>
                  </td><!-- 2018.01.25 ???? -->
                </tr>
                <tr> 
                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
				    ??</span>&nbsp;</td>
                  <td align=center bgcolor=f2f2f2><span class=style3>VAT????</span></td>
                  <td bgcolor=#FFFFFF>&nbsp;
                  	<%if(!e_bean.getEst_from().equals("tae_car")){%><!-- ???????????? ????????X(2018.03.29) -->
                  	<span class=style3>???????????? ?????? (<%=e_bean.getG_10()%>)?????? ???????? ???????? ????????. </span>
                  	<%} %>
                  </td>
                </tr>
                <tr> 
                  <td height=13 align=center bgcolor=f2f2f2><span class=style3>?? 
                    ?? </span></td>
                  <td align=right bgcolor=#FFFFFF><span class=style7><%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%> 
                    ??</span>&nbsp;</td>
                  <td colspan=2 bgcolor=f2f2f2> &nbsp;&nbsp;<span class=style3>???? ?????????? ???? ?????????? ?????????? ?????? ??????????.</span></td>
                </tr>
              </table></td>
          </tr>
		  <%if(e_bean.getIfee_s_amt()>0 && (AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10())>0 ){%>
          <tr> 
            <td height=2 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2"> <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                <tr> 
                  <td width=206 height=15 align=center bgcolor=f2f2f2><span class=style3>???????? 
                    ????????????</span></td>
                  <td width=82 align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>??</span></td>
                  <td width=346 bgcolor=#FFFFFF>&nbsp;<span class=style3>???????????? 
                    ?????? ?????? ???????? ??????????. </span></td>
                </tr>
              </table></td>
          </tr>
		  <%}%>
		  <%if(e_bean.getPp_ment_yn().equals("Y")){%>     
      <tr> 
		    <td colspan=2>&nbsp;<span class=style3>* ???????????? ???????? ???????? ???? ???????????? ?????? ?? ????????.</span></td>
      </tr>
      <%}%>		  		  
<!--??????????-->

<%		if(opt_chk.equals("1")){%>
                <tr> 
                    <td height=5 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"><img src=/acar/main_car_hp/images/bar_05_1_2014.gif></td>
                </tr>
                <tr> 
                    <td height=2 colspan="2"></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr> 
                                <td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
                                <td width=113 align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%><%}else{%><%=e_bean.getRo_13()%>%<%}%></span></td>
                                <td width=60 align=center bgcolor=f2f2f2><span class=style4>&nbsp;</span></td>
                                <td width=368 bgcolor=#FFFFFF align=left>&nbsp;<span class=style4>?????????? = ??????????</span></td>
                            </tr>
                            <tr> 
                                <td height=15 align=center bgcolor=f2f2f2><span class=style3>????????????</span></td>
                                <td align=right bgcolor=#FFFFFF><span class=style4><%if(e_bean.getRo_13()==0 ){%>???????? ????<%}else{%><%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>??<%}%></span>&nbsp;</td>
                                <td align=center bgcolor=f2f2f2><span class=style4>VAT????</span></td>
                                <td bgcolor=#FFFFFF align=left>&nbsp;<span class=style4>?? ?????????????? ?????????? ?????? ?? ???? ?????? ????????.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
<%		}%>
<!--??????????-->		  
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          <tr> 
            <td colspan="2">
	            	    <%		if(opt_chk.equals("1")){%>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_2.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- ???????????? ???? ???????????????? ???? 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_06_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_06_1.gif width=638 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_05_1_1.gif width=638 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- ???????????? ???? ???????????????? ???? 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_05_3.gif width=638 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_05.gif width=638 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%>            
            
            </td>
          </tr>
        <tr> 
			<td height=2 colspan="2"></td>
		</tr>
          <tr> 
          <td colspan="2" valign=top> 
          		<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                  	<tr> 
                     	<td width=92 height=15 align=center bgcolor=f2f2f2><span class=style3>??????????</span></td>
                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;<span class=style3><%if(!e_bean.getInsurant().equals("2")){%>* ???????? ?????? <b>???????? ???? ????</b><%}%> &nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;* <b>??????????????</b>(???????????? ????????)<%}%></span></td>
                    </tr>
                </table>
          </td>
         </tr>
         <tr></tr>
         <tr>
         	<td colspan="2">
                <table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                    <tr>
                       	<td colspan=2 align=center bgcolor=#f2f2f2 height=15><input type="checkbox" name="rent_way" value="3" <%if(!ej_bean.getJg_k().equals("0") && !rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>??????</b> (?????????? ?????? ????)</span></td>
                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<input type="checkbox" name="rent_way" value="1" <%if(!ej_bean.getJg_k().equals("0") && rent_way.equals("1")){%>checked<%}%> ><span class=style3 style="vertical-align:2px;"><b>??????</b> (?????????? ???? ????)</span></td>
                  	</tr>
                  	<tr>
                  		<td width=356 colspan=2 bgcolor=#FFFFFF height=80>&nbsp; <span class=style3><b>* ?????????? ??????</b></span><br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;- ???? ???? ???? ???? ?????????? ???? ????<br>
                  		<%if(!e_bean.getEst_st().equals("2")){%>
                  		&nbsp;&nbsp;&nbsp;&nbsp;- ???? ???? 2???? ???? ???? ???????? ????<%if(e_bean.getCar_comp_id().equals("0056")) {%>(?????????? ????)<%}%><br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24???? ???? ???????? ??????)<br> 
                  		&nbsp;&nbsp;&nbsp;&nbsp;- ???? ???? 2???? ????<%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;- <%}%> ???? ?????? ???? ???????? ????<br>
                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(???? ?????????? 15~30% ????, ?????? ????)</span></td>
                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style3><b>* ?????? ??????????</b></span><br>
                   		&nbsp;&nbsp;&nbsp;&nbsp;- ???? ??????????/?????? ????, ????, ????<br>
                   		&nbsp;&nbsp;&nbsp;&nbsp;- ?????? ???? ?????????? ????<br>
                   		&nbsp; <span class=style3><b>* ??????????????</b></span><br> 
                   		&nbsp;&nbsp;&nbsp;&nbsp;- 4???? ???? ???????? ??????</span></td>
                 	</tr>
         		</table>
         	</td>
        </tr>
          <tr> 
            <td height=5 colspan="2"></td>
          </tr>
          
          <!--??????????-->
          <%if(e_bean.getEst_from().equals("tae_car")){%>
          
          	<tr> 
		            <td colspan="2"><img src=../main_car_hp/images/bar_07_dc.gif></td>
				</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td height=40 bgcolor=ffffff> &nbsp;&nbsp;&nbsp;?? ?????????? ???? ???? ?????? ?????????? ???? ???? ???? ???????? ???? ??????????.<br> &nbsp;&nbsp;&nbsp;?????? ???? ???? ???? ?????? ?????? ???????????? ???? ????????, ???? ????/???? ???????? ???? ??????????.</td>
		            		</tr>
		            	</table>
		            </td>
				</tr>				
				          
          <%}else{%>
            <%if(first_rent_dt < 20220415){ // ???? ???????? 2022.04.14 ???????? ???? ???? %>
          		<tr> 
		            <td colspan="2"><%		if(opt_chk.equals("1")){%><img src=../main_car_hp/images/bar_07_yj_2014.gif><%}else{%><img src=../main_car_hp/images/bar_06_yj_2014.gif><%	}%></td>
				</tr>
				<tr> 
		            <td height=2 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2"> 
		            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=15 rowspan=2><span class=style3>????????????</span></td>
		            			<td bgcolor=ffffff rowspan=2 align=center><span class=style7><%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>km???? / 1??</span>
		            				<%if(!e_bean.getEst_st().equals("2") && AddUtil.parseInt(e_bean.getA_b()) <12){
	            						String agree_dist_m = AddUtil.parseFloatNotDot2(AddUtil.parseFloat(String.valueOf(e_bean.getAgree_dist()))/(12/AddUtil.parseFloat(e_bean.getA_b())));
	            				%>
	            				<br>??<%=AddUtil.parseDecimal(agree_dist_m)%>km???? / <%=e_bean.getA_b()%>????
	            				<%}%>
		            			</td>
		            			<td bgcolor=f2f2f2 height=15> &nbsp;<span class=style3>???? 1km?? <b>(<%=e_bean.getOver_run_amt()%>??)</b> (??????????)?? "<b>??????????????</b>"?? ??????(???? ??????)</span></td>
		            		</tr>
		            		
		            		<tr>
		            			<td bgcolor=ffffff height=15>
		            			  &nbsp;
		            			  <%if(opt_chk.equals("1")){%>
		            			  <%-- <span class=style3><%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>???????? ?????????? ???????????????? ??????????.<%}else{%>???????? ?????????? ???????????????? 50%?? ???????? ??????.<%}%></span> --%>
		            			  	<%if(e_bean.getRo_13()>0 ){%>
			            			  	<%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
			            			  		???????? ?????????? ???????????????? ??????????.
			            			  	<%}else if(e_bean.getA_a().equals("21") || e_bean.getA_a().equals("11")){ %>
			            			  	<%}else if(AddUtil.parseInt(e_bean.getA_b()) < 24){ %>	
			            			  	<%}else{%>???????? ?????????? (??????????????) ???????????? 40%?? ????????, (??????????????) ???????????????? 40%?? ???????? ??????.<%}%>
		            			  	<%}%>
		            			  <%}%>
		            			</td>
		            		</tr>
		            		
		            		<tr>
		            			<td align=center bgcolor=f2f2f2 height=15><span class=style3>??????????????</span></td>
		            			<td colspan=2 bgcolor=ffffff> &nbsp;<span class=style3>?????????????? ???????????? ?? ???????? <span class =style7><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%><%	if(e_bean.getMgr_ssn().equals("????????")){%>20<%}else{%>30<%}%><%}%>%</span> ?? ???????? ????</span></td>
		            		</tr>
		            	</table>
		            </td>
				</tr>
				
					<%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150217 && !e_bean.getEst_st().equals("2")){%>
                                <tr> 
				    <td colspan=2 height=22>&nbsp;<span class=style3>* ?????????????? ?????? ?????????? ????????, ?????????????? ?????? ?????????? ??????????.</span></td>
                                </tr>
					<%}%>
					<%} else {	// ???? ?????? 2022.04.15 ?????? ???? ???? ????%>
						<tr> 
		            		<td colspan="2">
		            		<%		if(opt_chk.equals("1")){%>
		            			<img src=../main_car_hp/images/bar_2022_07_yj.jpg>
		            		<%}else{%>
		            			<img src=../main_car_hp/images/bar_2022_06_yj.jpg>
		            		<%	}%>
		            		</td>
						</tr>
						<tr> 
				            <td height=2 colspan="2"></td>
						</tr>
						<tr> 
				            <td colspan="2"> 
				            	<table width=638 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
				            		<tr>
				            			<td align=center bgcolor=f2f2f2 height=15><span class=style3>??????????????</span></td>
				            			<td colspan=2 bgcolor=ffffff> &nbsp;<span class=style3>?????????????? ???????????? ?? ???????? <span class =style7><%if(e_bean.getCls_per()>0){%><%=AddUtil.parseFloatNotDot(e_bean.getCls_per())%><%}else{%><%	if(e_bean.getMgr_ssn().equals("????????")){%>20<%}else{%>30<%}%><%}%>%</span> ?? ???????? ????</span></td>
				            		</tr>
				            	</table>
				            </td>
						</tr>
					<%}%>
				<%}%>					
				<tr> 
		            <td height=5 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2"><%		if(opt_chk.equals("1")){%><img src=../main_car_hp/images/bar_08_2014.gif><%}else{%><img src=../main_car_hp/images/bar_07_2014.gif><%	}%></td>
				</tr>
				<tr> 
		            <td height=4 colspan="2"></td>
				</tr>
				<tr> 
		            <td colspan="2" align=center> 
		            	<table width=621 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=28 height=15 align=right><img src=../main_car_hp/images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=593 colspan=2 align=left class=listnum2><span class=style3>???????? ????, ???????? 
			                    ???? ???????????? ????(???? ???? ???? ????) </span></td>
			                </tr>
			                
			                <tr> 
			                  	<td height=15 align=right><img src=../main_car_hp/images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2><span class=style3>???????????? ???????? ???????????? ???????? [FMS(Fleet Management System)] </span></td>
			                </tr>
			                
			                <tr> 
			                  	<td height=15 align=right><img src=../main_car_hp/images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2><span class=style3>???????? ?????????? ????, ????????<%if((e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")) /* && !cm_bean.getDiesel_yn().equals("2") */ && AddUtil.parseInt(e_bean.getA_b()) >= 24){//?????? && ??LPG && 24???????? %>, ???????? ????<%}%> ?? ???? ????</span></td>
			                </tr>
			                
			                <!-- <tr> 
			                  	<td height=15 align=right><img src=../main_car_hp/images/4.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2><span class=style3>???????? ???? 
			                    ?????????? ????(????)???????? ????????(???????????? ????) </span></td>
			                </tr> -->
			                
			                <tr> 
			                  	<td colspan=4 height=3></td>
			                </tr>
			                <%-- <tr> 
			                  	<td height=24>&nbsp;</td>
			                  	<td>&nbsp;</td>
			                  	<td width=15><img src=../main_car_hp/images/arrow_1.gif width=10 height=6>&nbsp;</td>
			                  	<td width=569 align=left> 
			                  		<table width=569 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/img_bg.gif>
				                      	<tr> 
				                        	<td colspan=3><img src=../main_car_hp/images/img_up.gif width=569 height=5></td>
				                      	</tr>
				                     	<tr> 
				                        	<td width=15 height=15>&nbsp;</td>
				                        	<td width=270><img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
				                          	<span class=style3>???????? ????????</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_amt())%> ??</span></td>
				                        	<td width=284><img src=../main_car_hp/images/dot.gif width=5 height=5 align=absmiddle> 
				                          	<span class=style3>??????????(<%=e_bean.getA_b()%>??????)</span><span class=style13> 
				                          	|</span> <span class=style4><%=AddUtil.parseDecimal(e_bean.getGi_fee())%> ??</span></td>
				                      	</tr>
				                      	<tr> 
				                        	<td colspan=3><img src=../main_car_hp/images/img_dw.gif width=569 height=5></td>
				                      	</tr>
			                    	</table>
			                    </td>
			                </tr> --%>
		              	</table>
					</td>
				</tr>
          <tr> 
            <td height=3 colspan="2"></td>
          </tr>
          <tr> 
            <td align=right><img src=/acar/main_car_hp/images/ceo.gif>&nbsp;</td>
            <td align=right>&nbsp;&nbsp;</td>
          </tr>
        </table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>
</table>		
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
</body>
<script language="JavaScript" type="text/JavaScript">
function IE_Print(){
factory.printing.header = ""; //?????????? ????
factory.printing.footer = ""; //?????????? ????
factory.printing.portrait = true; //true-????????, false-????????    
factory.printing.leftMargin = 14.0; //????????   
factory.printing.rightMargin = 10.0; //????????
<%if(mail_yn.equals("")){%>
<%	if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
factory.printing.topMargin = 7.0; //????????    
factory.printing.bottomMargin = 0.0; //????????
<%	}else{%>
factory.printing.topMargin = 20.0; //????????    
factory.printing.bottomMargin = 7.0; //????????
<%	}%>
<%}else{%>
factory.printing.topMargin = 10.0; //????????    
factory.printing.bottomMargin = 7.0; //????????
<%}%>
factory.printing.Print(true, window);//arg1-????????????????(true or false), arg2-??????????or??????????
}

function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}
</script>	
</html>