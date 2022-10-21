<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.debt.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//건별 할부금 통계
	function cal_total(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.t_alt_prn.length;
		var prn = 0;
		var int = 0;
		var amt = 0;
		var t_y_cnt = 0;
		var t_y_prn = 0;
		var t_y_int = 0;
		var t_y_amt = 0;		
		var t_n_cnt = 0;
		var t_n_prn = 0;
		var t_n_int = 0;
		var t_n_amt = 0;				
		for(var i = 0 ; i < tm ; i ++){	
			prn += toInt(parseDigit(i_fm.t_alt_prn[i].value));
			int += toInt(parseDigit(i_fm.t_alt_int[i].value));
			amt += toInt(parseDigit(i_fm.t_alt_amt[i].value));			
			if(i_fm.t_pay_yn[i].value == 'Y'){
				t_y_cnt += 1;
				t_y_prn += toInt(parseDigit(i_fm.t_alt_prn[i].value));
				t_y_int += toInt(parseDigit(i_fm.t_alt_int[i].value));
				t_y_amt += toInt(parseDigit(i_fm.t_alt_amt[i].value));
			}else{
				t_n_cnt += 1;
				t_n_prn += toInt(parseDigit(i_fm.t_alt_prn[i].value));
				t_n_int += toInt(parseDigit(i_fm.t_alt_int[i].value));
				t_n_amt += toInt(parseDigit(i_fm.t_alt_amt[i].value));
			}						
		}
		//상환
		fm.t_y_cnt.value = parseDecimal(t_y_cnt);
		fm.t_y_prn.value = parseDecimal(t_y_prn);
		fm.t_y_int.value = parseDecimal(t_y_int);
		fm.t_y_amt.value = parseDecimal(t_y_amt);
		//잔책	
		fm.t_n_cnt.value = parseDecimal(t_n_cnt);
		fm.t_n_prn.value = parseDecimal(t_n_prn);
		fm.t_n_int.value = parseDecimal(t_n_int);
		fm.t_n_amt.value = parseDecimal(t_n_amt);
		//합계	
		fm.t_cnt.value = parseDecimal((t_n_cnt+t_y_cnt));
		fm.t_prn.value = parseDecimal((t_n_prn+t_y_prn));
		fm.t_int.value = parseDecimal((t_n_int+t_y_int));
		fm.t_amt.value = parseDecimal((t_n_amt+t_y_amt));						
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
		var idx 	= fm.idx.value;		
		if(fm.f_list.value == 'pay'){
			location = "/acar/con_debt/debt_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx;
		}else{
//			location = "/acar/forfeit_mng/forfeit_s_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}
	}		

	//세부페이지 이동(상단에서 바로 이동)
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
	
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String f_list = request.getParameter("f_list")==null?"pay":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String alt_tm = request.getParameter("alt_tm")==null?"":request.getParameter("alt_tm");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "01");
	
	if(m_id.equals("") && !alt_tm.equals("")){
		Hashtable debt_scd = ad_db.getDebtPayViewCase(c_id, lend_id, rtn_seq, alt_tm);
		m_id = String.valueOf(debt_scd.get("RENT_MNG_ID"));
		l_cd = String.valueOf(debt_scd.get("RENT_L_CD"));
	}
	
	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int tot_amt_tm = debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
	
	//휴/대차료 이름
	String h_title = "휴/대차료";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(mode.equals("view")){
		height = 450;
	}
%>
<form name='form1' action='' target='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=c_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='tot_amt_tm' value='<%=tot_amt_tm%>'>

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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 영업비용관리 > 할부금관리 > <span class=style5>할부금 상환 스케줄 수정(건별)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
    <tr>
        <td align="right" colspan=2>
<!--        	  <select name="gubun1">
          	  <option value="00" <%if(gubun1.equals("00")){%>selected<%}%>>==영업지원==</option>
          	  <option value="20" <%if(gubun1.equals("20")){%>selected<%}%>>계약관리</option>			  
          	  <option value="01" <%if(gubun1.equals("01")){%>selected<%}%>>==재무회계==</option>
          	  <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>대여료</option>
          	  <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>선수금</option>
          	  <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>과태료(수)</option>
          	  <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>면책금</option>
          	  <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>><%=h_title%></option>
          	  <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>중도해지</option>
          	  <option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>미수금정산</option>
              <option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>할부금</option>
              <option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>보험료</option>
              <option value="10" <%if(gubun1.equals("10")){%>selected<%}%>>과태료(지)</option>
              <option value="11" <%if(gubun1.equals("11")){%>selected<%}%>>지급수수료</option>																
              <option value="12" <%if(gubun1.equals("12")){%>selected<%}%>>매출비용</option>
          	  <option value="02" <%if(gubun1.equals("02")){%>selected<%}%>>==고객지원==</option>
          	  <option value="21" <%if(gubun1.equals("21")){%>selected<%}%>>정비/점검</option>			  
          	  <option value="22" <%if(gubun1.equals("22")){%>selected<%}%>>사고관리</option>
        	  </select>
        	  <input type="button" name="back" value="이동" onClick="javascript:page_move();">-->
        &nbsp;&nbsp;<a href='javascript:go_to_list()'><img src=../images/center/button_list.gif align=absmiddle border=0></a>	
        </td>
    </tr>
	<%}%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% class='title'>계약번호</td>
                    <td width=12%>&nbsp;<%=debt.getRent_l_cd()%></td>
                    <td width=10% class='title'>대출금액</td>
                    <td width=12%>&nbsp;<input type='text' name='t_lend_prn' size='10' value='<%=Util.parseDecimal(String.valueOf(debt.getLend_prn()))%>' class='whitenum' readonly> 원</td>
                    <td width=10% class='title'>대출번호</td>
                    <td width=12%>&nbsp;<%=debt.getLend_no()%></td>
                    <td width=10% class='title'>할부금융사</td>
                    <td width=24% colspan='3' align='left'>&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
                </tr>
                <tr> 
                    <td class='title'>할부횟수</td>
                    <td>&nbsp;
                      <input type='text' name='t_tot_amt_tm' size='3' value='<%=debt.getTot_alt_tm()%>' class='white' onBlur='javascript:blur()'>
                      회 </td>
                    <td class='title'>이율</td>
                    <td>&nbsp;<%=debt.getLend_int()%>% </td>
                    <td class='title'>할부수수료</td>
                    <td>&nbsp;<%=Util.parseDecimal(debt.getAlt_fee())%>원&nbsp;</td>
                    <td class='title'>공증료</td>
                    <td>&nbsp;<%=Util.parseDecimal(debt.getNtrl_fee())%>원&nbsp;</td>
                    <td class='title' width=6%>인지대</td>
                    <td>&nbsp;<%=Util.parseDecimal(debt.getStp_fee())%>원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>할부금</td>
                    <td>&nbsp;<%=Util.parseDecimal(debt.getAlt_amt())%>원 </td>
                    <td class='title'>약정일자</td>
                    <td>&nbsp;<%=debt.getRtn_est_dt()%>일</td>
                    <td class='title'>1회차결재일</td>
                    <td>&nbsp;<%=debt.getFst_pay_dt()%></td>
                    <td class='title'>1회차상환금액</td>
                    <td colspan='3'>&nbsp;<%=Util.parseDecimal(debt.getFst_pay_amt())%>원&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부금스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=8% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=12% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;약정일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=14% class='title'>할부원금</td>
                    <td width=14% class='title'>이자</td>
                    <td width=14% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;할부금&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=17% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;할부금 잔액&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=9% class='title'>&nbsp;&nbsp;&nbsp;결재여부&nbsp;&nbsp;&nbsp;</td>
                    <td width=12% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;결재일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width='17'>&nbsp;</td>
    </tr>
    <%	if(tot_amt_tm>=1){%>
    <tr> 
        <td colspan='2'> <iframe src="/acar/con_debt/debt_c_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&car_id=<%=c_id%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> </td>
    </tr>
    <tr> 
        <td colspan='2'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=10% class='title'>구분</td>
                    <td width=22% class='title'>회차</td>
                    <td width=22% class='title'>원금</td>
                    <td width=22% class='title'>이자</td>
                    <td width=24% class='title'>합계</td>
                </tr>
                <tr> 
                    <td class='title'>상환</td>
                    <td align='right'>
                      <input type='text' name='t_y_cnt' value='' size='12' class='whitenum' readonly>
                      회&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_y_prn' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_y_int' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_y_amt' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>잔액</td>
                    <td align='right'>
                      <input type='text' name='t_n_cnt' value='' size='12' class='whitenum' readonly>
                      회&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_n_prn' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_n_int' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_n_amt' value='' size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> 합계 </td>
                    <td align='right'>
                      <input type='text' name='t_cnt' value=''  size='12' class='whitenum' readonly>
                      회&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_prn' value=''  size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_int' value=''  size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td align='right'>
                      <input type='text' name='t_amt' value=''  size='12' class='whitenum' readonly>
                      원&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width='17'></td>
    </tr>
    <%	}else{%>
    <tr> 
        <td colsapn=2><br/>
        &nbsp;&nbsp;&nbsp;할부횟수가 세팅되지 않았습니다. <br/>
        <br/>
        &nbsp;&nbsp;&nbsp;계약 관리 메뉴에서 할부금내역을 입력한 후 스케줄을 작성하십시오</td>
    </tr>
    <%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
<script language='javascript'>
<!--
	var fm = document.form1;

	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = "";				
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
