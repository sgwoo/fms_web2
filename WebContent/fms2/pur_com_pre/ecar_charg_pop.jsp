<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.car_register.*, acar.client.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ec_bean" class="acar.car_office.EcarChargerBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_kd 				= request.getParameter("s_kd")				==null?"":request.getParameter("s_kd");
	String t_wd 				= request.getParameter("t_wd")				==null?"":request.getParameter("t_wd");
	String andor 				= request.getParameter("andor")				==null?"":request.getParameter("andor");
	String gubun1 			= request.getParameter("gubun1")			==null?"":request.getParameter("gubun1");
	String gubun2 			= request.getParameter("gubun2")			==null?"":request.getParameter("gubun2");
	String gubun3 			= request.getParameter("gubun3")			==null?"":request.getParameter("gubun3");
	String gubun4 			= request.getParameter("gubun4")			==null?"":request.getParameter("gubun4");
	String gubun5 			= request.getParameter("gubun5")			==null?"":request.getParameter("gubun5");
	String st_dt 				= request.getParameter("st_dt")				==null?"":request.getParameter("st_dt");
	String end_dt 			= request.getParameter("end_dt")			==null?"":request.getParameter("end_dt");
	
	String rent_l_cd 		= request.getParameter("rent_l_cd")		==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id 	= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String mode 				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	
	CarRegDatabase 			crd  = CarRegDatabase.getInstance();
	AddCarMstDatabase 	a_cmb = AddCarMstDatabase.getInstance();
	CarOffPreDatabase 		cop  = CarOffPreDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	ContBaseBean base  	= new ContBaseBean();
	ClientBean client 			= new ClientBean();
	CarMstBean mst			= new CarMstBean();
	CarRegBean cr_bean 	= new CarRegBean();
	boolean addr_chk = false;
	
	if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){
		//계약기본정보
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//고객정보
		client = al_db.getNewClient(base.getClient_id());
		//차량정보
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		//자동차회사&차종&자동차명
		mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
		if(mode.equals("U")){
			ec_bean = cop.getEcarChargerOne(rent_l_cd, rent_mng_id);
		}
	}
	
	
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.checked{		color:red;		}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
$(document).on(function(){

});
	//검색하기
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		window.open("about:blank", "search_cont", "left=10, top=10, width=700, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "search_cont";
		fm.action = "ecar_charg_search_cont.jsp"
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//충전기 타입에 따른 입력폼변경
	function change_type_form(val){
		if(val=='1'){
			$("#chg_type_1").css('display','table-row');
			$("#chg_type_2").css('display','none');
		}else if(val=='2'){
			$("#chg_type_1").css('display','none');
			$("#chg_type_2").css('display','table-row');
		}
	}
	
	//등록
	function save(mode){
		var fm = document.form1;
		//주소지 세팅
		var inst_loc_text = $("input[name='inst_loc_radio']:checked").val();
		if(inst_loc_text=="etc_addr"){
			fm.inst_zip.value = "";	
			fm.inst_loc.value = $("#etc_addr").val();
		}else{
			fm.inst_zip.value = inst_loc_text.split("//")[0];
			fm.inst_loc.value = inst_loc_text.split("//")[1];
		}
		if(fm.inst_loc.value==""){
			alert("충전기설치장소를 선택하거나 입력해주세요.");	return;
		}
		//충전기 설치 업체 세팅
		if(fm.chg_type.value=="1"){
			fm.inst_off_r.value = $("#inst_off1").val();
			if($("#inst_off1").val()=="91"){		fm.etc_inst_off.value = $("#etc_off_nm1").val();		}
		}else if(fm.chg_type.value=="2"){
			fm.inst_off_r.value = $("#inst_off2").val();
			if($("#inst_off2").val()=="92"){		fm.etc_inst_off.value = $("#etc_off_nm2").val();		}
		}else{													fm.etc_inst_off.value = "";
		}
		
		if((fm.chg_type.value=="1" && $("#inst_off1").val()=="")||(fm.chg_type.value=="2" && $("#inst_off2").val()=="")){
			alert("설치업체를 선택해주세요.");						return;
		}else if((fm.chg_type.value=="1" && $("#inst_off1").val()=="91") && fm.etc_inst_off.value==""){
			alert("설치업체-기타 의 설치업체를 입력해주세요.");	return;
		}else if((fm.chg_type.value=="2" && $("#inst_off2").val()=="92") && fm.etc_inst_off.value==""){
			alert("설치업체-기타 의 설치업체를 입력해주세요.");	return;
		}
		
		if(fm.chg_type.value=="1"){
			if(fm.pay_way.value==""){		alert("고객자부담 여부를 선택해주세요.");	return;	}
		}else if(fm.chg_type.value=="2"){
			if(fm.chg_prop.value==""){		alert("충전기 소유자를 선택해주세요.");		return;	}
		}
		
		if(mode=='I'){
			if(!confirm("등록하시겠습니까?")){	return;	}
			else{		fm.mode.value = "I";		}
		}else if(mode=='U'){
			if(!confirm("수정하시겠습니까?")){	return;	}
			else{		fm.mode.value = "U";		}
		}
		fm.action = "ecar_charg_a.jsp";
		fm.submit();
	}
	
	//설치업체 선택
	function chg_inst_off(chg_type, val){
			if(val=="91"||val=="92"){		$("#hidden_span"+chg_type).css("display","block");		}
			else{										$("#hidden_span"+chg_type).css("display","none");		}
	}
	
	//페이지 로딩 후 스크립트 처리
	function onload_fn(){
	<%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")&&mode.equals("U")){%>
			change_type_form('<%=ec_bean.getChg_type()%>');
			chg_inst_off('<%=ec_bean.getChg_type()%>', '<%=ec_bean.getInst_off()%>');
	<%}%>
	}
	
	function del(){	
		var fm = document.form1;
		if(!confirm("삭제하시겠습니까?")){	return;	}
		fm.mode.value = "D";
		fm.action = "ecar_charg_a.jsp";
		fm.submit();
	}
	
</script>
</head>

<body onload="javascript:onload_fn();">
<form name='form1' method='post'>
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="inst_zip" value="<%=ec_bean.getInst_zip()%>">
<input type="hidden" name="inst_loc" value="<%=ec_bean.getInst_loc()%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="client_id" value="<%=base.getClient_id()%>">
<input type="hidden" name="car_mng_id" value="<%=base.getCar_mng_id()%>">
<input type="hidden" name="etc_inst_off" value="<%=ec_bean.getEtc_inst_off()%>">
<input type="hidden" name="inst_off_r" value="">

<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">영업관리 > 계출관리 > 전기차 충전기 신청 ></span><span class="style5"> 등록 창 </span>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">
<%if(!mode.equals("U")){ %>
	<tr> 
  		<td><label><i class="fa fa-check-circle"></i> 계약 검색 </label>&nbsp;		
    		<select name='s_kd' class='select'>
      			<option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
				<option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차량번호</option>
			</select>
			<input type="text" name="t_wd" value="<%=t_wd%>" size="25" class='text input' onKeyDown="javasript:enter()" style='IME-MODE: active'>
			<button class='button' onclick='javascript:search();'>검색</button>		
      	</td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
	</tr>
<%} %>
    <%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){ %>
    <tr><td class=line2></td></tr>
    <tr> 
      	<td class=line> 
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
	        		<col width='10%'>
	        		<col width='15%'>
	        		<col width='10%'>
	        		<col width='*'>
	        		<col width='10%'>
	        		<col width='15%'>
        		</colgroup>
          		<tr>
		            <td class=title>계약번호</td>
		            <td align="center"><%=base.getRent_l_cd()%></td>
		            <td class=title>상호</td>
		            <td align="center"><%=client.getFirm_nm()%></td>
		            <td class=title>계약자 구분</td>
		            <td align="center">
		            	<%if(client.getClient_st().equals("1")){ 			out.println("법인");
		                      }else if(client.getClient_st().equals("2")){ out.println("개인");
		                      }else if(client.getClient_st().equals("3")){ out.println("개인사업자(일반과세)");
		                      }else if(client.getClient_st().equals("4")){	out.println("개인사업자(간이과세)");
		                      }else if(client.getClient_st().equals("5")){ out.println("개인사업자(면세사업자)"); }%>
		            </td>
          		</tr>
          		<tr>
		            <td class=title>차량번호</td>
		            <td align="center"><%=cr_bean.getCar_no()%></td>
		          	<td class=title>차명</td>
		            <td align="center"><%=mst.getCar_nm()%>&nbsp;<%=mst.getCar_name()%></td>
		            <td class=title></td>
		            <td align="center"></td>
          		</tr>
          		<tr>
          			<td class=title></td>
          			<td colspan="5"></td>
          		</tr>
        	</table>
      	</td>
	</tr>
   	<tr> 
      	<td>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>	
    <tr> 
    	<td class=line>
    		<table  border="0" cellspacing="1" width=100%>
				<colgroup>
					<col width="12%">
					<col width="45%">
					<col width="12%">
					<col width="*">
				</colgroup>
				<tr>
					<td class='title'>충전기<br>설치장소</td>
					<td colspan="3">
					<%if(client.getClient_st().equals("2")){//개인%>
						<%if(!client.getHo_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getHo_zip()%>//<%=client.getHo_addr()%>'
							 <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){		addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){%>class="checked"<%}%>>
							실주거지 : (<%=client.getHo_zip()%>)<%=client.getHo_addr()%></span><br>
						<%}%>						
						<%if(!client.getComm_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getComm_zip()%>//<%=client.getComm_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							직장 : (<%=client.getComm_zip()%>)<%=client.getComm_addr()%></span><br>
						<%}%>						 
					<%}else{//사업자%>
						<%if(!client.getO_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getO_zip()%>//<%=client.getO_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getO_zip()+"//"+client.getO_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							사업장주소 : (<%=client.getO_zip()%>)<%=client.getO_addr()%><br>
						<%}%>
						<%if(!client.getHo_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getHo_zip()%>//<%=client.getHo_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){	addr_chk = true;	%>checked<%}%>>
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							<%if(client.getClient_st().equals("1")){%> 본점소재지 : <%}else{%> 사업자주소 : <%}%> 
							(<%=client.getHo_zip()%>)<%=client.getHo_addr()%></span><br>
						<%}%>
						<%if(!client.getRepre_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getRepre_zip()%>//<%=client.getRepre_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getRepre_zip()+"//"+client.getRepre_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getRepre_zip()+"//"+client.getRepre_addr())){%>class="checked"<%} %>>
							대표자주소 : (<%=client.getRepre_zip()%>)<%=client.getRepre_addr()%></span><br>
						<%} %>	
					<%} %>
					<%if(!base.getP_addr().equals("")){%>
						<input type='radio' name='inst_loc_radio' value='<%=base.getP_zip()%>//<%=base.getP_addr()%>'
						<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(base.getP_zip()+"//"+base.getP_addr())){	addr_chk = true;	%>checked<%}%>> 
						<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(base.getP_zip()+"//"+base.getP_addr())){%>class="checked"<%} %>>
						우편물주소 : (<%=base.getP_zip()%>)<%=base.getP_addr()%></span><br>
					<%}%>
						<input type='radio' name='inst_loc_radio' value='etc_addr' <%if(addr_chk==false){ %>checked="checked"<%} %>> 
						기타 : <input type="text" class="text input" size="80" id="etc_addr" value="<%if(addr_chk==false){%><%=ec_bean.getInst_loc() %><%}%>" <%if(addr_chk==false){%>style='color:red;'<%}%>>
					</td>
				</tr>
				<tr>
					<td class='title'>충전기 타입</td>
					<td colspan="3">&nbsp;
						<select id='chg_type' name='chg_type' onchange="javascript:change_type_form(this.value);">
							<option value='1' <%if(ec_bean.getChg_type().equals("1")){%>selected<%} %>>이동형</option>
							<option value='2' <%if(ec_bean.getChg_type().equals("2")){%>selected<%} %>>고정형</option>
						</select>
					</td>
				</tr>
				<tr id='chg_type_1'>
					<td class='title' >설치업체</td>
					<td>&nbsp;
						<div style="float: left;">
							<select id='inst_off1' name='inst_off' onchange="javascript:chg_inst_off('1', this.value);">
								<option value=''>선택</option>
								<option value='1' <%if(ec_bean.getInst_off().equals("1")){%>selected<%} %>>파워큐브</option>
								<option value='2' <%if(ec_bean.getInst_off().equals("2")){%>selected<%} %>>매니지온(이볼트)</option>
								<option value='91' <%if(ec_bean.getInst_off().equals("91")){%>selected<%} %>>기타</option>
							</select>
						</div>
						<div id="hidden_span1" style="display:none; position: relative;">
							&nbsp;&nbsp;&nbsp;<input type="text" id="etc_off_nm1" value="<%if(ec_bean.getInst_off().equals("91")){%><%=ec_bean.getEtc_inst_off()%><%}%>">
						</div>
					</td>
					<td class='chg_type_1 title'>고객자부담</td>
					<td class='chg_type_1'>&nbsp;
						<select id='pay_way' name='pay_way'>
							<option value=''>선택</option>
							<option value='1' <%if(ec_bean.getPay_way().equals("1")){%>selected<%} %>>고객납부</option>
							<option value='2' <%if(ec_bean.getPay_way().equals("2")){%>selected<%} %>>견적반영</option>
						</select>
					</td>
				</tr>	
				<tr id='chg_type_2' style="display:none;">
					<td class='title'>설치업체</td>
					<td>&nbsp;
						<div style="float: left;">
							<select id='inst_off2' name='inst_off' onchange="javascript:chg_inst_off('2', this.value);">
								<option value=''>선택</option>
								<option value='11' <%if(ec_bean.getInst_off().equals("11")){%>selected<%} %>>대영채비</option>
								<option value='92' <%if(ec_bean.getInst_off().equals("92")){%>selected<%} %>>기타</option>
							</select>
						</div>
						<div id="hidden_span2" style="display:none; position: relative;">
							&nbsp;&nbsp;&nbsp;<input type="text" id="etc_off_nm2" value="<%if(ec_bean.getInst_off().equals("92")){%><%=ec_bean.getEtc_inst_off()%><%}%>">
						</div>
					</td>
					<td class='title'>토지, 건물 소유자</td>
					<td>&nbsp;
						<select id='chg_prop' name='chg_prop'>
							<option value=''>선택</option>
							<option value='1' <%if(ec_bean.getChg_prop().equals("1")){%>selected<%} %>>본인소유</option>
							<option value='2' <%if(ec_bean.getChg_prop().equals("2")){%>selected<%} %>>타인소유</option>
						</select>
					</td>
				</tr>
			</table>
    	</td>  	
    </tr>
    <%} %>
</table>
<div align="center">
<%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){ %>
	<%if(mode.equals("U")){ %>
		<%if(ck_acar_id.equals("000144") || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
			<input type='button' value='수정'  class='button' onclick="javascript:save('U');">
		<%} %>
		<%if(ck_acar_id.equals("000144") || ck_acar_id.equals(ec_bean.getReg_id()) ||nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
			<input type='button' value='삭제'  class='button' onclick="javascript:del();">
		<%} %>
	<%}else{ %>
		<input type='button' value='등록'  class='button' onclick="javascript:save('I');">
	<%} %>
<%} %>
    <input type='button' value='닫기'  class='button' onclick='javascript:window.close();'>
</div>
</form>
</body>
</html>