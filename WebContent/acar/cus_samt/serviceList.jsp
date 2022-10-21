<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.con_ser.*, acar.con_ins_m.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String h_title = "휴/대차료";
	
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>정비비</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//입금처리&입금취소&변경
	function change_scd(cmd, pay_yn, idx, accid_id, serv_id){
		var fm = document.form1;
		var i_fm = inner.form1;

		fm.accid_id.value = accid_id;
		fm.serv_id.value = serv_id;
		fm.cmd.value = cmd;
		fm.pay_yn.value = pay_yn;

		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.set_dt.value 	 = i_fm.set_dt.value;		
		}else{
			fm.set_dt.value 	 = i_fm.set_dt[idx].value;		
		}		

		if(replaceString("-","",fm.set_dt.value) == ""){	alert('지출일자를 확인하십시오');		return;		}

		if(cmd == 'p'){
			if(!confirm(toInt(idx)+1+'번 정비비를 '+fm.set_dt.value+'으로 출금처리하시겠습니까?')){
				return;
			}		
		}else{			
			if(!confirm(toInt(idx)+1+'번 정비비를 '+fm.set_dt.value+'으로 수정하시겠습니까?')){
				return;
			}
		}
		fm.action='set_dt_u.jsp';
		fm.target = 'i_no';
		fm.submit();		
	}

	//정비점검 세부 페이지 팝업
	function ServiceDisp(serv_id, serv_st, off_id){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var rent_mng_id = fm.m_id.value;
		var rent_l_cd = fm.l_cd.value;
		var car_mng_id = fm.c_id.value;
		var car_no = fm.car_no.value;
		var firm_nm = fm.firm_nm.value;
		var client_nm = fm.client_nm.value;	
		var url = "?auth_rw=" + auth_rw
				+ "&rent_mng_id=" + rent_mng_id 
				+ "&rent_l_cd=" + rent_l_cd
				+ "&car_mng_id=" + car_mng_id
				+ "&off_id=" + off_id 
				+ "&car_no=" + car_no
				+ "&firm_nm=" + firm_nm
				+ "&client_nm=" + client_nm
				+ "&serv_id="+ serv_id;	
	
		if(serv_st=='순회점검'){
			var SUBWIN="/acar/cus_reg/serv_reg.jsp" + url;
			window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
		}else if(serv_st=='일반수리'){
			var SUBWIN="/acar/cus_reg/serv_reg.jsp" + url;	
			window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
		}else if(serv_st=='보증수리'){
			var SUBWIN="/acar/cus_reg/serv_reg.jsp" + url;	
			window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
		}else if(serv_st=='사고수리'){
			var SUBWIN="/acar/cus_reg/serv_reg.jsp?cmd=4" + url;	
			window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=600,top=50,left=50');
		}
	}	
		
	//리스트로 가기
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
		var f_list 	= fm.f_list.value;	
		location = "cus_samt_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&f_list="+f_list;
	}	
	
//-->
</script>
</head>

<body>
<form name='form1' method='post'>
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
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='client_id' value='<%=fee.get("CLIENT_ID")%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='set_dt' value=''>
<input type='hidden' name='car_no' value='<%=fee.get("CAR_NO")%>'>
<input type='hidden' name='firm_nm' value='<%=fee.get("FIRM_NM")%>'>
<input type='hidden' name='client_nm' value='<%=fee.get("CLIENT_NM")%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 정비비관리 > <span class=style5>정비비 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
         <td align="right" colspan=2> 
            &nbsp;&nbsp;<a href="javascript:go_to_list()"  onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='8%' class='title'>계약번호</td>
                                <td width='12%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width='8%' class='title'>상호</td>
                                <td width='12%'>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width='8%' class='title'>고객명</td>
                                <td width='12%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width='8%' class='title'>차량번호</td>
                                <td width='12%'>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                                <td width='8%' class='title'>차명</td>
                                <td width='12%'>&nbsp;<%=fee.get("CAR_NM")%></td>
                            </tr>
                        </table>
                    </td>
                </tr>                   
                <tr></tr><tr></tr>
                <tr> 
                    <td colspan='14' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td class='title' width='8%'>특이사항</td>
                                <td>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr>
                                            <td>
                                            <%if(fee.get("ETC") != null){%>
                                            <%= fee.get("ETC")%>
                                            <%}%>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비 스케줄</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>&nbsp;&nbsp;연번&nbsp;&nbsp;</td>
                    <td width='9%' class='title'>&nbsp;&nbsp;&nbsp;정비일자&nbsp;&nbsp;&nbsp;</td>
                    <td width='8%' class='title'>&nbsp;&nbsp;정비구분&nbsp;&nbsp;</td>
                    <td width='7%' class='title'>&nbsp;&nbsp;담당자&nbsp;&nbsp;</td>
                    <td width='14%' class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정비업체&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width='9%' class='title'>&nbsp;&nbsp;&nbsp;주행거리&nbsp;&nbsp;&nbsp;</td>
                    <td width='10%' class='title'>&nbsp;&nbsp;&nbsp;&nbsp;정비금액&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width="10%" class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width='10%' class='title'>&nbsp;&nbsp;&nbsp;&nbsp;지출금액&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width='10%' class='title'>&nbsp;&nbsp;&nbsp;&nbsp;지출일자&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width='8%' class='title'>&nbsp;&nbsp;출금수정&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
        <td width=17>&nbsp;</td>
    </tr>		
    <tr> 
        <td colspan="2"><iframe src="serviceList_in.jsp?auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>" name="inner" width="100%" height="450" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
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
	s_fm.client_id.value = fm.client_id.value;	
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = fm.serv_id.value;
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>