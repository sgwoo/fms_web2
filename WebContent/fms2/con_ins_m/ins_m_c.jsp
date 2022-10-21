<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.con_ins_m.*, acar.car_mst.*, acar.account.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//입금처리&입금취소&변경
	function change_scd(cmd, pay_yn, idx, accid_id, serv_id, ext_tm){
		var fm = document.form1;
		var i_fm = i_in.form1;

		fm.accid_id.value = accid_id;
		fm.serv_id.value = serv_id;
		fm.cmd.value = cmd;
		fm.pay_yn.value = pay_yn;
		fm.ext_tm.value = ext_tm;
		
	//	alert(fm.cust_pay_dt.value);

		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.cust_amt.value	 = i_fm.cust_amt.value;
			fm.pay_amt.value	 = i_fm.pay_amt.value;
			fm.cust_plan_dt.value= i_fm.cust_plan_dt.value;	
			fm.cust_pay_dt.value = i_fm.cust_pay_dt.value;		
	//		fm.ext_dt.value 	 = i_fm.ext_dt.value;		
		}else{
			fm.cust_amt.value 	 = i_fm.cust_amt[idx].value;
			fm.pay_amt.value 	 = i_fm.pay_amt[idx].value;
			fm.cust_plan_dt.value= i_fm.cust_plan_dt[idx].value;	
			fm.cust_pay_dt.value = i_fm.cust_pay_dt[idx].value;
	//		fm.ext_dt.value 	 = i_fm.ext_dt[idx].value;		
		}	
			
	//	alert (i_fm.cust_amt[idx].value + "^" + i_fm.pay_amt[idx].value + "^" + i_fm.cust_pay_dt[idx].value );

		if(cmd == 'p'){
		
			if(replaceString("-","",fm.cust_pay_dt.value) == ""){	alert('입금일을 확인하십시오');		return;		}
			if((fm.pay_amt.value == '')||(fm.pay_amt.value == '0')||(fm.pay_amt.value.length > 10)){	alert('실입금액을 확인하십시오');	return;	}
			if(!confirm(toInt(idx)+1+'번 면책금을 '+fm.cust_pay_dt.value+'에 '+parseDigit(fm.pay_amt.value)+'원으로 입금처리하시겠습니까?')){
				return;
			}		
		}else if(cmd == 'c'){
			if(!confirm(toInt(idx)+1+'번 면책금이 ('+fm.cust_pay_dt.value+'에 '+parseDigit(fm.pay_amt.value)+'원 입금처리됨)를 \n 입금취소처리하시겠습니까?')){
				return;
			}
			fm.pay_amt.value = '0';
			fm.cust_pay_dt.value = '';
		}else if(cmd == 'd'){
			if(!confirm(toInt(idx)+1+'번 면책금이 ('+fm.cust_pay_dt.value+'에 '+parseDigit(fm.pay_amt.value)+'원 입금처리됨)를 \n 삭제처리하시겠습니까?')){
				return;
			}
		}else{			
			if(pay_yn == 'N'){
				if(fm.cust_amt.value == ''){	alert('청구금액을 확인하십시오');	return;	}
				if(!confirm(toInt(idx)+1+'번 면책금의 청구금액을 '+fm.cust_amt.value+'원으로 수정하시겠습니까?')){
					return;
				}
			}else{
				if(replaceString("-","",fm.cust_pay_dt.value) == " "){	alert('입금예정일을 확인하십시오');		return;		}
				if(!confirm(toInt(idx)+1+'번 면책금의 입금일자를 '+fm.cust_pay_dt.value+'으로 수정하시겠습니까?')){
					return;
				}
			}
		}
		fm.action='/fms2/con_ins_m/mod_scd_u.jsp';
		fm.target = 'i_no';
		fm.submit();		
	}
	
	//입금표발행
	function reg_payebill(cmd, pay_yn, idx, accid_id, serv_id, ext_tm){
		var fm = document.form1;

		fm.accid_id.value = accid_id;
		fm.serv_id.value = serv_id;
		fm.cmd.value = cmd;
		fm.pay_yn.value = pay_yn;
		fm.ext_tm.value = ext_tm;
		
		fm.action='/fms2/con_ins_m/payebill_i.jsp';
		fm.target = '_blank';
		fm.submit();		
	}
		
	
	//세부내용 보기	
	function view_cont(accid_id, serv_id, serv_st){
		var fm = document.form1;
		var m_id 	= fm.m_id.value;
		var l_cd 	= fm.l_cd.value;
		var c_id 	= fm.c_id.value;		
		window.open("/fms2/con_ins_m/sub_cont.jsp?gubun=m&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&serv_id="+serv_id+"&serv_st="+serv_st, "CONT", "left=100, top=100, width=700, height=300 scrollbars=yes");
	}

	//특이사항 보기	
	function see_etc(){
		var fm = document.form1;
		var m_id 	= fm.m_id.value;
		var l_cd 	= fm.l_cd.value;
		var c_id 	= fm.c_id.value;		
		var client_id = fm.client_id.value;
		var etc 	= fm.etc.value;
		var firm_nm = fm.firm_nm.value;
		var client_nm = fm.client_nm.value;		
		var auth 	= fm.auth.value;
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
		window.open("/fms2/con_ins_m/etc_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&client_id="+client_id+"&etc="+etc+"&firm_nm="+firm_nm+"&client_nm="+client_nm+"&auth="+auth+"&auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc, "ETC", "left=100, top=100, width=500, height=225");
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
		location = "/fms2/con_ins_m/ins_m_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx;
	}	
	

	
	function  viewDepoSlip(depoSlippubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var depoSlip = window.open("about:blank", "depoSlip", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=750px, height=700px");
		document.depoSlipListForm.action="https://www.trusbill.or.kr/jsp/directDepo/DepoSlipViewIndex.jsp";
		document.depoSlipListForm.method="post";
		document.depoSlipListForm.depoSlippubCode.value=depoSlippubCode;
		document.depoSlipListForm.docType.value="P"; 	//입금표
		document.depoSlipListForm.userType.value="S"; 	// S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.depoSlipListForm.target="depoSlip";
		document.depoSlipListForm.submit();
		document.depoSlipListForm.target="_self";
		document.depoSlipListForm.depoSlippubCode.value="";
		depoSlip.focus();
		return;
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")){ 	user_id = login.getCookieValue(request, "acar_id"); }
	if(br_id.equals("")){	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "04"); }
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	String brch_id = String.valueOf(fee.get("BRCH_ID"));
	//연체료 셋팅
	boolean flag = ae_db.calDelay(m_id, l_cd, "3");
	//통계
	IncomingBean ins_m = ae_db.getInsurMScdStat(m_id, l_cd, c_id);
		
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-120;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name="depoSlipListForm" method="get">
	<input type="hidden" name="depoSlippubCode" >
	<input type="hidden" name="docType" >
	<input type="hidden" name="userType" >
</form>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='client_id' value='<%=fee.get("CLIENT_ID")%>'>
<input type='hidden' name='etc' value='<%=fee.get("ETC")%>'>
<input type='hidden' name='firm_nm' value='<%=fee.get("FIRM_NM")%>'>
<input type='hidden' name='client_nm' value='<%=fee.get("CLIENT_NM")%>'>

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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='cust_amt' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='cust_pay_dt' value=''>
<input type='hidden' name='cust_plan_dt' value=''>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='ext_tm' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
	    <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 면책금 관리 > <span class=style5>면책금 스케줄 조회 및 수금</span></span></td>
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

              &nbsp;<a href='javascript:go_to_list()'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
		  	  &nbsp;<a href='javascript:history.go(-1);'><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a> 
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
                                <td width=8% class='title'>계약번호</td>
                                <td width=10%>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width=8% class='title'>상호</td>
                                <td width=15%>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width=8% class='title'>고객명</td>
                                <td width=8%>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width=8% class='title'>차량번호</td>
                                <td width=10%>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                                <td width=8% class='title'>차명</td>
                                <td width=17%>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 9)%></span></td>
                            </tr>
                            <tr> 
                                <td class='title' width=8%>특이사항</td>
                                <td width=92% colspan=9>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr>
                                            <td>
                                                <%if(fee.get("ETC") != null) {%>
                                                <%= fee.get("ETC")%>
                                                <%}%>
                                                </td>
                                        </tR>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td></td>
    </tr>
    <tr>		
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>면책금 수금 스케쥴</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='4%' class='title' style='height:44'>연번</td>
                    <td width='7%' class='title'>정비구분</td>
                    <td width='10%' class='title'>정비업체</td>
                    <td width='9%' class='title'>정비금액</td>
                    <td width='9%' class='title'>청구금액</td>
                    <td class='title' width="9%">입금예정일</td>
                    <td width='8%' class='title'>입금일자 </td>
                    <td width='9%' class='title'>실입금액 </td>
                    <td class='title' width="8%">세금계산서<br>발행일자</td>			
                    <td width='5%' class='title'>연체<br>일수 </td>
                    <td width='6%' class='title'>연체료</td>
                    <td width='10%' class='title'>입금<br>취소</td>
                    <td class='title' width="6%">수정<br>삭제</td>
                </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>	
    <tr>
	    <td colspan='2'>
	    <iframe src="/fms2/con_ins_m/ins_m_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&brch_id=<%=brch_id%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
    <tr>		
        <td align='right'> 
          <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href='javascript:see_etc()'><img src=/acar/images/center/button_modify_e.gif align=absmiddle border=0></a><%}%> 
        </td>
    	<td width='17'>&nbsp;</td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>		
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>면책금 통계</span></td>
    </tr>
    <tr>
	    <td>
	        <table width='100%'>
		        <tr>
		            <td width='50%'>
            			<table border="0" cellspacing="0" cellpadding="0" width=100%>
            			    <tr>
            			        <td class=line2></td>
            			    </tr>
            			    <tr>
            				    <td width='100%' class='line'>
            				        <table border="0" cellspacing="1" cellpadding="0" width=100%%>
                                        <tr> 
                                            <td class='title' width=25%>구분</td>
                                            <td class='title' width=25%>건수</td>
                                            <td class='title' width=50%>청구금액</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>미수금</td>
                                            <td align='right'><%=ins_m.getTot_su1()%>건&nbsp;&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(ins_m.getTot_amt1()))%>원&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>수금</td>
                                            <td align='right'><%=ins_m.getTot_su2()%>건&nbsp;&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(ins_m.getTot_amt2()))%>원&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>합계</td>
                                            <td align='right'><%=ins_m.getTot_su1()+ins_m.getTot_su2()%>건&nbsp;&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(ins_m.getTot_amt1()+ins_m.getTot_amt2()))%>원&nbsp;&nbsp;</td>
                                        </tr>
                                    </table>
            				    </td>
            		        </tr>
            	        </table>
			        <td width='10%'></td>
			        <td width='39%' valign='top'>
			            <table border="0" cellspacing="0" cellpadding="0" width=100%>
			                <tr>
            			        <td class=line2></td>
            			    </tr>
            				<tr>
            				    <td class='line'>
            					    <table border="0" cellspacing="1" cellpadding="0" width=100%>
            					        <tr>
            						        <td class='title' width='40%'>연체건수</td>
            						        <td align='right' width='60%'><%=ins_m.getTot_su3()%>건&nbsp;&nbsp;</td>
            					        </tr>
            					        <tr>
            					  	        <td class='title'>연체료계</td>
            						        <td align='right'><%=Util.parseDecimal(String.valueOf(ins_m.getTot_amt3()))%>원&nbsp;&nbsp;</td>
            					        </tr>
            					    </table>								
            				    </td>
            				</tr>
			            </table>
			        </td>
			        <td width='20'>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--

//-->
</script>  
</body>
</html>
