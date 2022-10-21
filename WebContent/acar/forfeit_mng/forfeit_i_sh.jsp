<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.cont.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//계약번호, 상호, 차량번호로 계약 조회
	function CarRentSearch(arg){
		var fm = document.form1;
		var l_cd = "";
		var firm_nm = "";
		var car_no = "";
		var keyValue = event.keyCode;
		if (keyValue =='13'){
			if(arg=="rent_l_cd"){
				l_cd = fm.l_cd.value;
			}else if(arg=="firm_nm"){
				firm_nm = fm.firm_nm.value;
			}else if(arg=="car_no"){
				car_no = fm.car_no.value;
			}
			var SUBWIN="./car_rent_list.jsp?gubun="+arg+"&l_cd="+l_cd+"&firm_nm="+firm_nm+"&car_no="+car_no;	
			window.open(SUBWIN, "CarRentList", "left=100, top=100, width=820, height=400, scrollbars=yes");
		}
	}

	//등록
	function ForfeitReg(){
		var fm = document.form1;
		if(fm.seq_no.value!=""){	alert("수정만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.cmd.value = "i";
		fm.h_paid_amt.value = parseDigit(fm.paid_amt.value);
		fm.vio_dt.value = fm.vio_ymd.value + "" + fm.vio_s.value + "" +fm.vio_m.value; 
		fm.target = "nodisplay"
		fm.action = "forfeit_null_ui.jsp";		
		fm.submit();
	}

	//수정
	function ForfeitUp(){
		var fm = document.form1;
		if(fm.seq_no.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.cmd.value = "u";
		fm.h_paid_amt.value = parseDigit(fm.paid_amt.value);
		fm.vio_dt.value = fm.vio_ymd.value + "" + fm.vio_s.value + "" +fm.vio_m.value;
		fm.target = "nodisplay";
		fm.action = "forfeit_null_ui.jsp";		
		fm.submit();
	}

	//삭제
	function ForfeitDel(){
		var fm = document.form1;
		if(fm.seq_no.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		fm.cmd.value = "d";
		fm.h_paid_amt.value = parseDigit(fm.paid_amt.value);
		fm.vio_dt.value = fm.vio_ymd.value + "" + fm.vio_s.value + "" +fm.vio_m.value;
		fm.target = "nodisplay";
		fm.action = "forfeit_null_ui.jsp";
		fm.submit();
	}

	//고지서번호 중복 체크
	function PaidNoCheck(){
		var fm1 = document.form1;
		var fm2 = document.form2;
		if(fm1.cmd.value!="up"){
			fm2.h_paid_no.value = fm1.paid_no.value;
			fm2.ch_gu.value = "paid_no";
			fm2.target = "nodisplay";
			fm2.submit();
		}
	}

	function Vio_dtCheck(){
		var fm1 = document.form1;
		var fm2 = document.form2;
		if(fm1.cmd.value!="up"){
			fm2.h_vio_dt.value = fm1.vio_ymd.value + "" + fm1.vio_s.value + "" +fm1.vio_m.value; 
			fm2.ch_gu.value = "vio_dt";			
			fm2.target = "nodisplay";
			fm2.submit();
		}	
	}
	function ClearM(){
		var fm = document.form1;
		fm.vio_ymd.value='';
		fm.vio_s.value='';
		fm.vio_m.value='';
		fm.tel.value='';
		fm.fax.value='';
		fm.vio_pla.value='';
		fm.vio_cont.value='';
		fm.paid_no.value='';
		fm.rec_dt.value=replaceString(" ","",getTodayBar());
		fm.paid_end_dt.value='';
		fm.paid_amt.value='';
		fm.h_paid_amt.value='';
		fm.proxy_dt.value='';
		fm.dem_dt.value='';
		fm.pol_sta.value='';
		fm.rec_plan_dt.value='';
		fm.coll_dt.value='';
		fm.note.value='';
		fm.cmd.value='';
		fm.seq_no.value='';
		fm.call_nm.value='';
		fm.vio_dt.value='';
		fm.no_paid_yn.checked = false;	
		fm.no_paid_cau.value='';		
		fm.update_id.value='';		
		fm.update_dt.value='';		
		fm.obj_dt1.value =replaceString(" ","",getAddDateBar(fm.rec_dt.value, 1));
		fm.obj_dt2.value = '';
		fm.obj_dt3.value ='';
		fm.f_dem_dt.value = '';
		fm.e_dem_dt.value = '';
	}
	//이의신청일 셋팅
	function setTomaDate(){
		var fm = document.form1;
		fm.obj_dt1.value =replaceString(" ","",getAddDateBar(fm.rec_dt.value, 1));	
	}
	//날짜 포맷 변환
	function ChangeDT( arg ){
		var fm = document.form1;
		if(arg=="vio_ymd"){				fm.vio_ymd.value = ChangeDate(fm.vio_ymd.value);
		}else if(arg=="rec_dt"){		fm.rec_dt.value = ChangeDate(fm.rec_dt.value);
		}else if(arg=="paid_end_dt"){	fm.paid_end_dt.value = ChangeDate(fm.paid_end_dt.value);
		}else if(arg=="proxy_dt"){		fm.proxy_dt.value = ChangeDate(fm.proxy_dt.value);
		}else if(arg=="dem_dt"){		fm.dem_dt.value = ChangeDate(fm.dem_dt.value);
		}else if(arg=="coll_dt"){		fm.coll_dt.value = ChangeDate(fm.coll_dt.value);
		}else if(arg=="rec_plan_dt"){	fm.rec_plan_dt.value = ChangeDate(fm.rec_plan_dt.value);
		}
	}
	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.l_cd.value==""){			alert("계약번호를 입력하십시요");	fm.l_cd.focus();	return false;	}
		if(fm.firm_nm.value==""){		alert("상호를 입력하십시요");		fm.firm_nm.focus();	return false;	}
		if(fm.car_no.value==""){		alert("차량번호를 입력하십시요");	fm.car_no.focus();	return false;	}
		if(fm.vio_ymd.value==""){		alert("위반일자를 입력하십시요");	fm.vio_ymd.focus();	return false;	}
		if(fm.vio_s.value==""){			alert("위반시간을 입력하십시요");	fm.vio_s.focus();	return false;	}
		if(fm.vio_m.value==""){			alert("위반시간를 입력하십시요");	fm.vio_m.focus();	return false;	}
		if(fm.vio_pla.value==""){		alert("위반장소를 입력하십시요");	fm.vio_pla.focus();	return false;	}
		if(fm.vio_cont.value==""){		alert("위반내용를 입력하십시요");	fm.vio_cont.focus();return false;	}
		if(fm.pol_sta.value==""){		alert("경찰서를 입력하십시요");		fm.pol_sta.focus();	return false;	}
		if(fm.paid_no.value==""){		alert("납부고지서번호를 입력하십시요");	fm.paid_no.focus();return false;}
		if(fm.rec_dt.value==""){		alert("영수일자를 입력하십시요");	fm.rec_dt.focus();	return false;	}
		if(fm.paid_end_dt.value==""){	alert("납부기한 입력하십시요");		fm.paid_end_dt.focus();return false;}
		if(fm.paid_amt.value==""){		alert("납부금액을 입력하십시요");	fm.paid_amt.focus();return false;	}
		return true;
	}

	function set_amt(){
		var fm = document.form1;
		if(fm.vio_cont.value == "주차위반" || fm.vio_cont.value == "주정차위반") fm.paid_amt.value = parseDecimal("40000");
	}

  //청구기관 코드변환
  function set_pol(){
		var fm = document.form1;		
		if(fm.pol_sta.value == "01"){
		  fm.pol_sta.value = '영등포경찰서';
    }else if(fm.pol_sta.value  == "02"){
      fm.pol_sta.value = '파주경찰서';
    }
  }
  
	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		if(fm.f_list.value == 'in'){
			location = "/acar/con_forfeit/forfeit_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}else{
			location = "/acar/forfeit_mng/forfeit_s_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}
	}		
	
	//세부페이지 이동
	function page_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/fms2/con_fee/fee_c_mgr.jsp";
		else if(idx == '2') url = "/acar/con_grt/grt_u.jsp";
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_c.jsp";
		else if(idx == '4') url = "/acar/con_ins_m/ins_m_c.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_c.jsp";
		else if(idx == '6') url = "/acar/con_cls/cls_c.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_c.jsp";		
		else if(idx == '8') url = "/acar/con_debt/debt_c.jsp?f_list=pay";		
		else if(idx == '9') url = "/acar/con_ins/ins_u.jsp?f_list=now";		
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_i_frame.jsp";		
		else if(idx == '11') url = "/acar/commi_mng/commi_u.jsp";										
		else if(idx == '12') url = "/acar/mng_exp/exp_c.jsp";		
		else if(idx == '20') url = "/acar/car_rent/con_reg_frame.jsp?mode=2";				
		else if(idx == '21') url = "/acar/car_service/service_i_frame.jsp?mode=2";				
		else if(idx == '22') url = "/acar/car_accident/car_accid_i_frame.jsp?cmd=u";								
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}			

	//엑셀 
	function pop_excel(){
		var fm = document.form1;	
		fm.target = "_blak";
		fm.action = "case_excel.jsp";
		fm.submit();
	}		
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
//-->
</script>
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"10":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"in":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	//계약:고객관련
	ContBaseBean base = a_db.getContBaseAll(m_id, l_cd);
	if(c_id.equals("")) c_id = base.getCar_mng_id();
//	if(seq_no.equals("")) seq_no = "1";
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	rl_bean = fdb.getCarRent(c_id, m_id, l_cd);

	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	FineBean f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);
	
	//휴/대차료 이름
	String h_title = "휴/대차료";
	if(!rl_bean.getCar_no().equals("")){
		if(rl_bean.getCar_no().substring(4,5).equals("허")) 	h_title = "휴차료";
		else													h_title = "대차료";
	}
%>
<form action="./forfeit_null_ui.jsp" name="form1" method="POST" >
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type="hidden" name="vio_dt" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td width="400"><font color="navy">계약관리 -> 과태금/범칙금 -> </font><font color="red">수정</font></td>
      <td width="400" align="right">
	  </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border=0 cellspacing=1 width=800>
          <tr> 
            <td class=title>계약번호</td>
            <td align="center"> 
              <input type="text" name="l_cd" size="18" value="<%=rl_bean.getRent_l_cd()%>" class=text onKeydown="CarRentSearch('rent_l_cd')">
            </td>
            <td class=title>계약자</td>
            <td align="center"> 
              <input type="text" name="client_nm" size="18" value="<%=rl_bean.getClient_nm()%>" class=whitetext readonly>
            </td>
            <td class=title>상호</td>
            <td align="center" colspan="3"> 
              <input type="text" name="firm_nm" size="52" value="<%=rl_bean.getFirm_nm()%>" class=text onKeydown="CarRentSearch('firm_nm')">
            </td>
          </tr>
          <tr> 
            <td width="80" class=title>차량번호</td>
            <td width="120" align="center"> 
              <input type="text" name="car_no" size="18" value="<%=rl_bean.getCar_no()%>" class=text onKeydown="CarRentSearch('car_no')">
            </td>
            <td width="80" class=title>차종</td>
            <td width="120" align="left"> 
              <input type="text" name="car_name" size="18" value="<%=rl_bean.getCar_nm()%><%//=rl_bean.getCar_name()%>" class=whitetext readonly>
            </td>
            <td width="80" class=title>대여방식</td>
            <td width="120" align="left"> 
              <input type="text" name="rent_way_nm" size="18" value="<%=rl_bean.getRent_way_nm()%>" class=whitetext readonly>
            </td>
            <td width="80" class=title>대여기간</td>
            <td width="120" align="left"> 
              <input type="text" name="con_mon" size="2" value="<%=rl_bean.getCon_mon()%>" class=whitetext readonly>
              개월</td>
          </tr>
          <tr> 
            <td class=title>연락처</td>
            <td align="left"> 
              <input type="text" name="o_tel" size="18" value="<%=rl_bean.getO_tel()%>" class=whitetext readonly>
            </td>
            <td class=title>팩스</td>
            <td align="left"> 
              <input type="text" name="o_fax" size="18" value="<%=rl_bean.getFax()%>" class=whitetext readonly>
            </td>
            <td class=title>대여개시일</td>
            <td align="left"> 
              <input type="text" name="rent_start_dt" size="18" value="<%=rl_bean.getRent_start_dt()%>" class=whitetext readonly>
            </td>
            <td width="80" class=title>계약서스캔</td>
            <td width="120" align="center">
              <%if(!rl_bean.getScan_file().equals("")){%>
              <a href="javascript:view_map(<%=rl_bean.getScan_file()%>);">계약서 
              보기</a>
              <%}else{%>
			  <a class=index1 href="javascript:MM_openBrWindow('upload.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&mode=<%=mode%>&gubun=pdf','popwin','scrollbars=no,status=no,resizable=yes,width=500,height=100,left=250, top=250')">
			  스캔</a>
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border=0 cellspacing=1 width="800">
          <tr> 
            <td>< 위반사항 ></td>
            <td width="500" align="right"><font color="#999999">♧ 담당자 : 백미경 &nbsp;&nbsp; 
              ♧ 최종수정자:
              <input type="text" name="update_id" size="6" value="<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>" class=white readonly>
              &nbsp;&nbsp; ♧ 최종수정일 :
              <input type="text" name="update_dt" size="9" value="<%=Util.htmlR(f_bean.getUpdate_dt())%>" class=white readonly>
              </font> </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border=0 cellspacing=1 width=800>
          <tr> 
            <td class=title width="70">구분</td>
            <td width="160"> 
              <select name="fine_st">
                <option value="1" <%if(f_bean.getFine_st().equals("1"))%>selected<%%>>과태료</option>
                <option value="2" <%if(f_bean.getFine_st().equals("2"))%>selected<%%>>범칙금</option>
              </select>
            </td>
            <td class=title width="60">통화자</td>
            <td width="70"> 
              <input type="text" name="call_nm" value="<%=f_bean.getCall_nm()%>" size="9" class=text style='IME-MODE: active'>
            </td>
            <td width="65" class=title>전화번호</td>
            <td width="80"> 
              <input type="text" name="tel" value="<%=f_bean.getTel()%>" size="12" class=text>
            </td>
            <td class=title width="70">팩스</td>
            <td colspan=3> 
              <input type="text" name="fax" value="<%=f_bean.getFax()%>" size="12" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="70">위반일시</td>
            <td width="160"> 
              <input type="text" name="vio_ymd" value="<%=AddUtil.ChangeDate2(f_bean.getVio_dt().substring(0,8))%>" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('vio_ymd')">
              <input type="text" name="vio_s" value="<%=f_bean.getVio_dt().substring(8,10)%>" size="2" maxlength=2 class=text>
              시 
              <input type="text" name="vio_m" value="<%=f_bean.getVio_dt().substring(10,12)%>" size="2" maxlength=2 class=text onBlur="javascript:Vio_dtCheck()">
              분 </td>
            <td class=title width="60">위반장소</td>
            <td colspan=7> 
              <input type="text" name="vio_pla" value="<%=f_bean.getVio_pla()%>" size="60" class=text maxlength="50" style='IME-MODE: active'>
            </td>
          </tr>
          <tr> 
            <td class=title width="70">위반내용</td>
            <td colspan="3"> 
              <input type="text" name="vio_cont" value="<%=f_bean.getVio_cont()%>" size="30" class=text onBlur="javascript:set_amt()" style='IME-MODE: active'>
            </td>
            <td width="65" class=title>청구기관</td>
            <td colspan="5"> 
              <input type="text" name="pol_sta" value="<%=f_bean.getPol_sta()%>" size="25" class=text maxlength="30" onBlur="javascript:set_pol()">
              (01:영등포경찰서,02:파주경찰서) </td>
          </tr>
          <tr> 
            <td class=title width="70">고지서번호</td>
            <td colspan="3"> 
              <input type="text" name="paid_no" value="<%=f_bean.getPaid_no()%>" size="30" class=text onBlur="javascript:PaidNoCheck()" style='IME-MODE: inactive'>
            </td>
            <td class=title>과실구분</td>
            <td> 
              <select name="fault_st">
                <option value="1" <%if(f_bean.getFault_st().equals("1"))%>selected<%%>>고객과실</option>
                <option value="2" <%if(f_bean.getFault_st().equals("2"))%>selected<%%>>업무상과실</option>
              </select>
            </td>
            <td class=title width="70">업무과실자</td>
            <td> 
              <input type="text" name="fault_nm" value="<%=f_bean.getFault_nm()%>" size="6" maxlength=10 class=text style='IME-MODE: active'>
            </td>
            <td class=title width="70">업무과실자<br>
              부담금액</td>
            <td> 
              <input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="7" maxlength=6 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
            </td>
          </tr>
          <tr> 
            <td class=title width="70">납부구분</td>
            <td width="160"> 
              <select name="paid_st">
                <option value="1" <%if(f_bean.getPaid_st().equals("1"))%>selected<%%>>납부자변경</option>
                <option value="2" <%if(f_bean.getPaid_st().equals("2"))%>selected<%%>>고객납입</option>
                <option value="4" <%if(f_bean.getPaid_st().equals("4"))%>selected<%%>>수금납입</option>
                <option value="3" <%if(f_bean.getPaid_st().equals("3"))%>selected<%%>>회사대납</option>
              </select>
            </td>
            <td width="60" class=title>고지서<br>
              접수일</td>
            <td width="70"> 
              <input type="text" name="rec_dt" value="<%=f_bean.getRec_dt()%>" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('rec_dt');"><!-- setTomaDate()-->
            </td>
            <td class=title>납부기한</td>
            <td> 
              <input type="text" name="paid_end_dt" value="<%=f_bean.getPaid_end_dt()%>" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('paid_end_dt')">
            </td>
            <td class=title>납부금액</td>
            <td width="70"> 
              <input type="hidden" name="h_paid_amt" value="<%=Util.parseDecimal(f_bean.getPaid_amt())%>">
              <input type="text" name="paid_amt" value="<%=Util.parseDecimal(f_bean.getPaid_amt())%>" size="9" maxlength=6 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
            </td>
            <td width="60" class=title>납부일자</td>
            <td> 
              <input type="text" name="proxy_dt" value="<%=f_bean.getProxy_dt()%>" size="12" maxlength=10 class=text onBlur="javascript:ChangeDT('proxy_dt')">
            </td>
          </tr>
          <tr> 
            <td class=title width="70">이의신청</td>
            <td colspan="3"> 1차: 
              <input type="text" name="obj_dt1" value="<%=f_bean.getObj_dt1()%>" size="12" maxlength=12 class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              2차: 
              <input type="text" name="obj_dt2" value="<%=f_bean.getObj_dt2()%>" size="12" maxlength=12 class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              3차: 
              <input type="text" name="obj_dt3" value="<%=f_bean.getObj_dt3()%>" size="12" maxlength=12 class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td class=title>청구일자</td>
            <td> 
              <input type="text" name="dem_dt" value="<%=f_bean.getDem_dt()%>" maxlength=10 class=text onBlur="javascript:ChangeDT('dem_dt')" size="11">
            </td>
            <td class=title>입금예정일</td>
            <td> 
              <input type="text" name="rec_plan_dt" value="<%=f_bean.getRec_plan_dt()%>" size="12" maxlength=10 class=text onBlur="javascript:ChangeDT('rec_plan_dt')">
            </td>
            <td class=title>수금일자</td>
            <td> 
              <input type="text" name="coll_dt" value="<%=f_bean.getColl_dt()%>" size="11" maxlength=10 class=text onBlur="javascript:ChangeDT('coll_dt')">
            </td>
          </tr>
          <tr> 
            <td class=title width="70">특이사항</td>
            <td colspan=9> 
              <textarea name="note" cols=110 rows=2><%=f_bean.getNote()%></textarea>
            </td>
          </tr>
          <tr> 
            <td class=title width="70">거래명세서<br>
              포함여부</td>
            <td> 
              <select name="bill_doc_yn">
                <option value="0" <%if(f_bean.getBill_doc_yn().equals("0"))%>selected<%%>>미포함</option>
                <option value="1" <%if(f_bean.getBill_doc_yn().equals("1"))%>selected<%%>>포함</option>
              </select>
            </td>
            <td width="60" class=title>부가세<br>
              포함여부</td>
            <td width="70"> 
              <select name="vat_yn">
                <option value="0" <%if(f_bean.getVat_yn().equals("0"))%>selected<%%>>미포함</option>
                <option value="1" <%if(f_bean.getVat_yn().equals("1"))%>selected<%%>>포함</option>
              </select>
            </td>
            <td class=title>세금계산서<br>
              발행여부</td>
            <td> 
              <select name="tax_yn">
                <option value="0" <%if(f_bean.getTax_yn().equals("0"))%>selected<%%>>미발행</option>
                <option value="1" <%if(f_bean.getTax_yn().equals("1"))%>selected<%%>>발행</option>
              </select>
            </td>
            <td class=title>최초청구일</td>
            <td> 
              <input type="text" name="f_dem_dt" value="<%=f_bean.getF_dem_dt()%>" size="9" maxlength=10 class=whitetext>
            </td>
            <td class=title>최종청구일</td>
            <td> 
              <input type="text" name="e_dem_dt" value="<%=f_bean.getE_dem_dt()%>" size="9" maxlength=10 class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="70">거래구분</td>
            <td> 
              <select name="busi_st">
                <option value="1" <%if(f_bean.getBusi_st().equals("1"))%>selected<%%>>과태료</option>
                <option value="2" <%if(f_bean.getBusi_st().equals("2"))%>selected<%%>>차량수리</option>
              </select>
            </td>
            <td class=title>면제여부</td>
            <td colspan="7"> 
              <input type='checkbox' name='no_paid_yn' value="Y" <%if(f_bean.getNo_paid_yn().equals("Y"))%>checked<%%>>
              사유: 
              <input type="text" name="no_paid_cau" value="<%=f_bean.getNo_paid_cau()%>" size="70" class=text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border=0 cellspacing=1 width="800">
          <tr> 
            <td align=right> 
              <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
              <%//if(auth_rw.equals("R/W")){%>
       	      <a href="javascript:ForfeitReg()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
              &nbsp;&nbsp;<a href="javascript:ForfeitUp()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
   	          &nbsp;&nbsp;<a href="javascript:ForfeitDel()"><img src="/images/del.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
       	      &nbsp;&nbsp;<a href="javascript:ClearM()"><img src="/images/init.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
              <%}%>
              &nbsp;&nbsp;<a href="javascript:go_to_list()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	  	 	  &nbsp;&nbsp;<a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true"><img src="/images/reload.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border=0 cellspacing=1 width="800">
          <tr> 
            <td align="left" width="399">< 위반리스트 ></td>
            <td align="right" width="400"><input type="button" name="excel" value="Excel" onClick="javascript:pop_excel();" title="과태료 공문"></td>
          </tr>
        </table>
      </td>
    </tr>
	<tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td><iframe src="./forfeit_i_sc_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>" name="ForFeitList" width="800" height="190" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<form action="./paid_no_check.jsp" name="form2" method="post">
<input type="hidden" name="h_paid_no" value="">
<input type="hidden" name="h_vio_dt" value="">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type="hidden" name="ch_gu" value="">
</form>
<script language='javascript'>
<!--
	var fm = document.form1;

	//바로가기
	var s_fm = parent.parent.d_search.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = "";				
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = fm.serv_id.value;
	s_fm.seq_no.value = fm.seq_no.value;
-->
</script>  
</body>
</html>
