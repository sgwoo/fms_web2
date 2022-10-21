<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	//팝업윈도우 열기
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int serv_seq = request.getParameter("serv_seq")==null?0:Util.parseInt(request.getParameter("serv_seq"));
	String serv_dt	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String park_id	= request.getParameter("park_id")==null?"":request.getParameter("park_id");
	int car_km = request.getParameter("car_km")==null?0:Util.parseInt(request.getParameter("car_km"));

	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");
	
	Vector vt = pk_db.ParkingList(car_mng_id);
	int vt_size = vt.size();
	
	int i=0;

%>	

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">

<!--
/* Title 고정 */
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
//	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}	


function CheckList(park_id,io_gubun, park_seq, c_id, seq, serv_dt, e_oil, cool_wt, ws_wt, e_clean, out_clean, tire_air, tire_mamo, lamp, in_clean, wiper, car_sound, panel, front_bp, back_bp, lh_fhd, lh_bhd, lh_fdoor, lh_bdoor, rh_fhd, rh_bhd, rh_fdoor, rh_bdoor, energy, goods1, goods2, goods3, goods4, goods5, goods6, goods7, goods8, goods9, goods10, goods11, goods12, goods13, e_oil_ny, cool_wt_ny, ws_wt_ny, e_clean_ny, out_clean_ny, tire_air_ny, tire_mamo_ny, lamp_ny, in_clean_ny, wiper_ny, car_sound_ny, panel_ny, front_bp_ny, back_bp_ny, lh_fhd_ny, lh_bhd_ny, lh_fdoor_ny, lh_bdoor_ny, rh_fhd_ny, rh_bhd_ny, rh_fdoor_ny, rh_bdoor_ny, energy_ny, car_km, gita, area){

		var fm = parent.parent.c_foot.document.form1;
		fm.park_id.value = park_id;
		fm.io_gubun.value = io_gubun;
		fm.car_mng_id.value = c_id;
		fm.serv_seq.value = seq;
		fm.serv_dt.value = serv_dt;
		fm.e_oil.value = e_oil;
		fm.cool_wt.value = cool_wt;
		fm.ws_wt.value = ws_wt;
		fm.e_clean.value = e_clean;
		fm.out_clean.value = out_clean;
		fm.tire_air.value  = tire_air;
		fm.tire_mamo.value = tire_mamo;
		fm.lamp.value = lamp;
		fm.in_clean.value = in_clean;
		fm.wiper.value = wiper;
		fm.car_sound.value = car_sound;
		fm.panel.value = panel;
		fm.front_bp.value = front_bp;
		fm.back_bp.value = back_bp;
		fm.lh_fhd.value = lh_fhd;
		fm.lh_bhd.value = lh_bhd;
		fm.lh_fdoor.value = lh_fdoor;
		fm.lh_bdoor.value = lh_bdoor;
		fm.rh_fhd.value = rh_fhd;
		fm.rh_bhd.value = rh_bhd;
		fm.rh_fdoor.value = rh_fdoor;
		fm.rh_bdoor.value = rh_bdoor;
		fm.energy.value = energy;
		fm.goods1.value = goods1;
		fm.goods2.value = goods2;
		fm.goods3.value = goods3;
		fm.goods4.value = goods4;
//		fm.goods5.value = goods5;
//		fm.goods6.value = goods6;
		fm.goods7.value = goods7;
		fm.goods8.value = goods8;
//		fm.goods9.value = goods9;
		fm.goods10.value = goods10;
		fm.goods11.value = goods11;
//		fm.goods12.value = goods12;
		fm.goods13.value = goods13;
		fm.e_oil_ny.value = e_oil_ny;
		fm.cool_wt_ny.value = cool_wt_ny;
		fm.ws_wt_ny.value = ws_wt_ny ; 
		fm.e_clean_ny.value = e_clean_ny;
		fm.out_clean_ny.value = out_clean_ny;
		fm.tire_air_ny.value = tire_air_ny;
		fm.tire_mamo_ny.value = tire_mamo_ny;
		fm.lamp_ny.value = lamp_ny;
		fm.in_clean_ny.value = in_clean_ny;
		fm.wiper_ny.value = wiper_ny;
		fm.car_sound_ny.value = car_sound_ny;
		fm.panel_ny.value = panel_ny;
		fm.front_bp_ny.value = front_bp_ny;
		fm.back_bp_ny.value = back_bp_ny;
		fm.lh_fhd_ny.value = lh_fhd_ny;
		fm.lh_bhd_ny.value = lh_bhd_ny;
		fm.lh_fdoor_ny.value = lh_fdoor_ny;
		fm.lh_bdoor_ny.value = lh_bdoor_ny;
		fm.rh_fhd_ny.value = rh_fhd_ny;
		fm.rh_bhd_ny.value = rh_bhd_ny;
		fm.rh_fdoor_ny.value = rh_fdoor_ny;
		fm.rh_bdoor_ny.value = rh_bdoor_ny;
		fm.energy_ny.value = energy_ny;
		fm.car_km.value = car_km;
		fm.gita.value = gita;
		fm.area.value = area;
		fm.park_seq.value = park_seq;
		
		fm.submit();
			  	
}
//-->
</script>
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>

<input type='hidden' name='park_id' value='<%=park_id%>'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_km" value="<%=car_km%>">

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 ></td></tr>
	<tr id='tr_title'  >		
		<td class='line' width='100%' id='td_title' style='position:relative;'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td class='title' width=10%>연번</td>
					<td class='title' width=21%>차고지</td>
					<td class='title' width=21%>점검자</td>
					<td class='title' width=25%>점검일시</td>
					<td class='title' width=23%>주행거리</td>
				</tr>
			</table>
		</td>
		<td width=1%>&nbsp;</td>
	</tr>
<%if(vt_size > 0){
	for( i = 0 ; i < vt_size ; i++){
		Hashtable reserv = (Hashtable)vt.elementAt(i);%>		
	<tr >		
		<td class='line' > 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td align="center" width=10%><%=i+1%></td>
					<td align="center" width=21%><%if(reserv.get("PARK_ID").equals("1")){%>영남주차장<%}else if(reserv.get("PARK_ID").equals("2")){%>파천교<%}else if(reserv.get("PARK_ID").equals("3")){%>부산지점<%}else if(reserv.get("PARK_ID").equals("4")){%>대전지점<% }else if(reserv.get("PARK_ID").equals("8")){%>부산조양
										<%}else if(reserv.get("PARK_ID").equals("7")){%>부산부경 <%}else if(reserv.get("PARK_ID").equals("9")){%> 대전현대 <%} else if(reserv.get("PARK_ID").equals("11")){%> 대전금호
								<%} else if(reserv.get("PARK_ID").equals("12")){%> 광주지점<%} else if(reserv.get("PARK_ID").equals("13")){%> 대구지점					<%   }	%> </td>
					
					<td align="center" width=21%><%=reserv.get("USER_NM")%></td>
					<td align="center" width=25%>
					<a href="javascript:CheckList('<%=reserv.get("PARK_ID")%>', '<%=reserv.get("IO_GUBUN")%>', '<%=reserv.get("PARK_SEQ")%>', '<%=reserv.get("CAR_MNG_ID")%>','<%=reserv.get("SERV_SEQ")%>','<%=reserv.get("SERV_DT")%>','<%=reserv.get("E_OIL")%>','<%=reserv.get("COOL_WT")%>','<%=reserv.get("WS_WT")%>',
																				'<%=reserv.get("E_CLEAN")%>','<%=reserv.get("OUT_CLEAN")%>','<%=reserv.get("TIRE_AIR")%>','<%=reserv.get("TIRE_MAMO")%>','<%=reserv.get("LAMP")%>','<%=reserv.get("IN_CLEAN")%>','<%=reserv.get("WIPER")%>','<%=reserv.get("CAR_SOUND")%>','<%=reserv.get("PANEL")%>','<%=reserv.get("FRONT_BP")%>','<%=reserv.get("BACK_BP")%>','<%=reserv.get("LH_FHD")%>','<%=reserv.get("LH_BHD")%>','<%=reserv.get("LH_FDOOR")%>','<%=reserv.get("LH_BDOOR")%>','<%=reserv.get("RH_FHD")%>','<%=reserv.get("RH_BHD")%>','<%=reserv.get("RH_FDOOR")%>','<%=reserv.get("RH_BDOOR")%>','<%=reserv.get("ENERGY")%>','<%=reserv.get("GOODS1")%>','<%=reserv.get("GOODS2")%>','<%=reserv.get("GOODS3")%>','<%=reserv.get("GOODS4")%>','<%=reserv.get("GOODS5")%>','<%=reserv.get("GOODS6")%>','<%=reserv.get("GOODS7")%>','<%=reserv.get("GOODS8")%>','<%=reserv.get("GOODS9")%>','<%=reserv.get("GOODS10")%>','<%=reserv.get("GOODS11")%>','<%=reserv.get("GOODS12")%>','<%=reserv.get("GOODS13")%>','<%=reserv.get("E_OIL_NY")%>','<%=reserv.get("COOL_WT_NY")%>','<%=reserv.get("WS_WT_NY")%>','<%=reserv.get("E_CLEAN_NY")%>','<%=reserv.get("OUT_CLEAN_NY")%>','<%=reserv.get("TIRE_AIR_NY")%>','<%=reserv.get("TIRE_MAMO_NY")%>','<%=reserv.get("LAMP_NY")%>','<%=reserv.get("IN_CLEAN_NY")%>','<%=reserv.get("WIPER_NY")%>','<%=reserv.get("CAR_SOUND_NY")%>','<%=reserv.get("PANEL_NY")%>','<%=reserv.get("FRONT_BP_NY")%>','<%=reserv.get("BACK_BP_NY")%>','<%=reserv.get("LH_FHD_NY")%>','<%=reserv.get("LH_BHD_NY")%>','<%=reserv.get("LH_FDOOR_NY")%>','<%=reserv.get("LH_BDOOR_NY")%>','<%=reserv.get("RH_FHD_NY")%>','<%=reserv.get("RH_BHD_NY")%>','<%=reserv.get("RH_FDOOR_NY")%>','<%=reserv.get("RH_BDOOR_NY")%>','<%=reserv.get("ENERGY_NY")%>','<%=reserv.get("CAR_KM")%>','<%=reserv.get("GITA")%>','<%=reserv.get("AREA")%>')
																				"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("SERV_DT")))%></a>
						<% if(reserv.get("GUBUN").equals("1")){%>
							&nbsp;(입고)
						<%}else{ %>
							&nbsp;(출고)														
						<%} %>														
					</td>
					<td align="right" width=23%><%=Util.parseDecimal(String.valueOf(reserv.get("CAR_KM")))%> km</td>
				</tr>
			</table>
		</td>
	</tr>
	<%}%>
<%}else{	%>                    
	<tr>		
		<td class='line' > 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
	</tr>
 <%	}	%>		
</table>

</form>
</body>
</html>

