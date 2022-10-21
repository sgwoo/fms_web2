<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*, acar.cls.*, acar.fee.*, acar.cont.*,acar.client.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String page_st = request.getParameter("page_st")==null?"":request.getParameter("page_st");
	String use_end_dt = "";
	String accid_id = "";
	String serv_id = "";
	
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "07", "03");
	
	//계약정보
	Hashtable ht = s_db.getContSettleInfo(l_cd);
	
	if(client_id.equals("")) 	client_id 	= (String)ht.get("CLIENT_ID");
	if(m_id.equals("")) 		m_id 		= (String)ht.get("RENT_MNG_ID");
	if(c_id.equals("")) 		c_id 		= (String)ht.get("CAR_MNG_ID");
	
	//업체정보
	ClientBean client = al_db.getClient(client_id);
	
	//연체료 세팅
	boolean flag = af_db.calDelay(m_id, l_cd);
	int fee_dly_pay_amt = s_db.getDlyPayAmt(m_id, l_cd, client_id, mode);
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 20; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//계약별에서 상호별로
	function view_client_all(){
		var fm = document.form1;
		fm.mode.value = "client";		
		fm.action = 'settle_c.jsp';
		fm.target = 'd_content';	
		fm.submit();
	}
	
	//상호별에서 계약별로
	function view_cont_case(m_id, l_cd){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;		
		fm.mode.value = "cont";		
		fm.action = 'settle_c.jsp';
		fm.target = 'd_content';	
		fm.submit();
	}
	
	//하단페이지 이동
	function move_subpage(idx){
		var fm = document.form1;
		var url = "";
		if(idx == '0') 		url = "pre_list_in.jsp";
		else if(idx == '1') url = "fee_list_in.jsp";
		else if(idx == '2') url = "fine_list_in.jsp";
		else if(idx == '3') url = "serv_list_in.jsp";
		else if(idx == '4') url = "accid_list_in.jsp";
		else if(idx == '5') url = "cls_list_in.jsp";
		else if(idx == '6') url = "rent_list_in.jsp";
		else if(idx == '7') url = "credit_list_in.jsp";
		else if(idx == '8') url = "end_est_list_in.jsp";
		fm.action = url;
		fm.target = 'sub_in';	
		fm.submit();
	}
		
	//스케줄 이동(하단에서 스케줄로 이동)
	function move_scd(idx, m_id, l_cd, c_id, accid_id, serv_id){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;		
		fm.c_id.value = c_id;	
		fm.accid_id.value = accid_id;		
		fm.serv_id.value = serv_id;						
		fm.seq_no.value = accid_id;								
		fm.gubun1.value = toInt(idx)+1;
		fm.s_cd.value = l_cd;			
		var url = "";
		if(idx == '0') 		url = "/fms2/con_fee/fee_c_mgr.jsp";
		else if(idx == '1') url = "/fms2/con_grt/grt_u.jsp";
//		else if(idx == '2') url = "/acar/con_forfeit/forfeit_c.jsp";
		else if(idx == '2') url = "/acar/fine_mng/fine_mng_frame.jsp";
		else if(idx == '3') url = "/fms2/con_ins_m/ins_m_c.jsp";
	//	else if(idx == '4') url = "/acar/con_ins_h/ins_h_c.jsp";
		else if(idx == '4') url = "/fms2/con_ins_h/ins_h_c.jsp";
		else if(idx == '5') url = "/fms2/con_cls/cls_c.jsp";		
		else if(idx == '6') url = "/acar/con_rent/res_fee_c.jsp";		
		else if(idx == '7') url = "/acar/stat_credit/credit_c.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();				
	}

	//세부페이지 이동(상단에서 바로 이동)
	function page_move2(idx)
	{
		var fm = document.form1;
		var url = "";
		if(idx == '1') 		url = "/fms2/con_fee/fee_c_mgr.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_u.jsp";
//		else if(idx == '3') url = "/acar/con_forfeit/forfeit_c.jsp";
		else if(idx == '3') url = "/acar/fine_mng/fine_mng_frame.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_c.jsp";
		else if(idx == '5') url = "/fms2/con_ins_h/ins_h_c.jsp";
	//	else if(idx == '5') url = "/acar/con_ins_h/ins_h_c.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_c.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_c.jsp";		
		else if(idx == '8') url = "/acar/con_debt/debt_c.jsp?f_list=pay";		
		else if(idx == '9') url = "/acar/con_ins/ins_u.jsp?f_list=now";		
//		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_i_frame.jsp";		
		else if(idx == '10') url = "/acar/fine_mng/fine_mng_frame.jsp";		
		else if(idx == '11') url = "/acar/commi_mng/commi_u.jsp";										
		else if(idx == '12') url = "/acar/mng_exp/exp_c.jsp";		
		else if(idx == '20') url = "/acar/car_rent/con_reg_frame.jsp?mode=2";				
		else if(idx == '21') url = "/acar/car_service/service_i_frame.jsp?mode=2";				
		else if(idx == '22') url = "/acar/car_accident/car_accid_i_frame.jsp?cmd=u";								
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		<%if(page_st.equals("fee")){%>	
		fm.action = '/fms2/con_fee/fee_frame_s.jsp';
		<%}else{%>
		fm.action = '/acar/settle_acc/settle_s_frame.jsp';		
		<%}%>	
		fm.mode.value = '';
		fm.target = 'd_content';	
		fm.submit();
	}	
	function view_memo()
	{
		var auth_rw = document.form1.auth_rw.value;		
		var m_id = document.form1.m_id.value;		
		var l_cd = document.form1.l_cd.value;						
		
//		window.open("memo_frame_s.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd, "MEMO", "left=100, top=100, width=800, height=650");
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}		
	//고객 보기
	function view_client(){
		var m_id = document.form1.m_id.value;		
		var l_cd = document.form1.l_cd.value;			
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	
	//중도해지정산  보기
	function view_settle(m_id, l_cd){
		window.open("../cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE", "left=100, top=10, width=700, height=700, scrollbars=yes, status=yes");		
	}
	
	//대손채권 이동
	function credit_move(){
		var fm = document.form1;
		fm.action = '/acar/stat_credit/credit_c.jsp';		
		fm.target = 'd_content';	
		fm.submit();							
	}			
	
	//대손채권 이동
	function view_settle_doc(){
		var fm = document.form1;
		fm.action = '/fms2/settle_acc/bad_debt_doc.jsp';		
		fm.target = 'd_content';	
		fm.submit();							
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='settle_c.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
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
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='s_cd' value=''>
<input type='hidden' name='serv_id' value=''>
<input type='hidden' name='seq_no' value=''>
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='fee_dly_pay_amt' value='<%=fee_dly_pay_amt%>'>		
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 미수금정산 관리 > <span class=style5>미수금정산 조회</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right">
        <img src=../images/center/arrow_gji.gif align=absmiddle> : <input type='text' name='today' size='10' value='<%=today%>' class='whitetext'>
		<%if(!mode.equals("client")){%>
        <a href="javascript:view_memo()" title=""><img src=../images/center/button_tel.gif align=absmiddle border=0></a>
        <a href="javascript:view_settle('<%=m_id%>','<%=l_cd%>');"><img src=../images/center/button_js_jdhg.gif align=absmiddle border=0></a>		
		<%}%>
		</td>
    </tr>
    <%if(mode.equals("client")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=10%>상호</td>
                    <td>&nbsp;&nbsp;<a href="javascript:view_client()"><b><%=client.getFirm_nm()%></b></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>계약번호</td>
                    <td colspan="7">&nbsp;<%=ht.get("RENT_L_CD")%>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td>&nbsp;<a href="javascript:view_client_all();"><%=ht.get("FIRM_NM")%></a></td>
                    <td class='title'>고객명</td>
                    <td>&nbsp;<%=ht.get("CLIENT_NM")%></td>
                    <td class='title'>대여차명</td>
                    <td colspan="3">&nbsp;<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=ht.get("CAR_NO")%></b></font></td>
                    <td class='title'>등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                    <td class='title'>대여기간</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>&nbsp;~&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                </tr>
                <tr> 
                    <td class='title'>총대여기간</td>
                    <td >&nbsp;<%=ht.get("CON_MON")%>개월</td>
                    <td class='title'>실이용기간</td>
                    <td>&nbsp;<%=ht.get("U_MON")%>개월&nbsp;<%=ht.get("U_DAY")%>일</td>
                    <td class='title'>대여방식</td>
                    <td colspan="3">&nbsp;<%=ht.get("RENT_WAY")%></td>
                </tr>
                <tr> 
                    <td class='title' width=10%>월대여료</td>
                    <td width=18%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("FEE_AMT")))%> 
                      원&nbsp;</td>
                    <td class='title' width=10%>보증금액</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT1")))%> 
                      원&nbsp;</td>
                    <td width=10% class='title'>선납금액</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT2")))%> 
                      원&nbsp;</td>
                    <td width=10% class='title'>개시대여료</td>
                    <td width=12%>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)ht.get("PP_AMT3")))%> 
                      원&nbsp;</td>
                </tr>
                <%if(!String.valueOf(ht.get("CLS_DT")).equals("")){ //해지된 계약이면%>
                <tr> 
                    <td class='title'>해지내역 </td>
                    <td colspan="7"> &nbsp;<%=ht.get("CLS_CAU")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <%}%>
    <tr> 
        <td align='right' colspan="2"><a href='javascript:go_to_list()'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
	    <a href='javascript:history.go(-1);'><img src=../images/center/button_back_p.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <%if(mode.equals("client")){%>  
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약리스트</span></td>
        <td width="17">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class='title'>연번</td>
                    <td width=12% class='title'>계약번호</td>
                    <td width=10% class='title'>차량번호</td>
                    <td width=20% class='title'>차명</td>
                    <td width=15% class='title'>계약기간</td>
                    <td width=11% class='title'>실이용기간</td>
                    <td width=9% class='title'>대여방식</td>
                    <td width=9% class='title'>영업담당</td>
                    <td width=9% class='title'>대여구분</td>
                </tr>    
            </table>
        </td>
        <td width="17">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2"> 
		<iframe src="/acar/settle_acc/cont_list_in.jsp?client_id=<%=client_id%>&today=<%=today%>" name="cont_in" width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</iframe> 
	    </td>
  	</tr>	
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>			
<%}%>	
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>미수금정산</span></td>
    </tr>
	<%	//미수금 정산(미도래분포함)
		Hashtable ht1 = s_db.getContSettleCase1("1", m_id, l_cd, client_id, mode, gubun2, today);
		//미수금 정산-연체
		Hashtable ht2 = s_db.getContSettleCase1("2", m_id, l_cd, client_id, mode, gubun2, today);
		//연체료 정산
		Hashtable ht3 = s_db.getContSettleCase2("", m_id, l_cd, client_id, mode, gubun2, today);
		//대손처리
		Hashtable ht4 = s_db.getContSettleCase3("", m_id, l_cd, client_id, mode, gubun2, today);
		
		Vector fee_lists = s_db.getEndEstList(m_id, l_cd, client_id, mode, gubun2, today);
		int fee_size = fee_lists.size();
		long total_amt 	= 0;
		if(fee_size > 0){
			for (int i = 0 ; i < fee_size ; i++){
				Hashtable fee_list = (Hashtable)fee_lists.elementAt(i);
				total_amt += AddUtil.parseLong(String.valueOf(fee_list.get("AMT")));
			}
		}
	%>
    <tr> 
        <td> 
	        <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <tr>
                    <td class=line2 colspan=6></td>
                </tr>
                <tr> 
                    <td class=line width=10%>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td class='title' style='height:45'>&nbsp;<br>구분<br>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td class='title'><a href="javascript:move_subpage('0');">선수금</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('1');">대여료</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('2');">과태료</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('3');">면책금</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('4');">휴/대차료</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('5');">해지정산금</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('6');">단기요금</a></td>
                            </tr>
                            <tr>
                                <td class='title'><a href="javascript:move_subpage('8');">미청구+잔가</a></td>
                            </tr>
                            <tr> 
                                <td class='title'>합계</td>
                            </tr>
                        </table>
                    </td>
                    <td class=line>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr>
                                <td class='title' colspan="2">미수금(미도래포함)</td>
                            </tr>
                            <tr>
                                <td class='title' >건수</td>
                                <td class='title' >금액</td>
                            </tr>
            			  <%	int  cnt1[]   = new int[8];
            			  		long amt1[]   = new long[8];
            					for(int j=0; j<8; j++){
            							cnt1[j]  += AddUtil.parseInt(String.valueOf(ht1.get("EST_SU"+j)));
            							amt1[j]  += AddUtil.parseLong(String.valueOf(ht1.get("EST_AMT"+j)));
            					}%>
            			  <%	for(int j=1; j<8; j++){%>
                            <tr>
                                <td align='center'><input type="text" name="n_su1" size="3" value="<%=cnt1[j]%>" class="whitenum">
                  			    건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt1" size="10" value="<%=Util.parseDecimal(amt1[j])%>" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>
            			  <%	}%>
                            <tr>
                                <td align='center'><input type="text" name="n_su1" size="3" value="0" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt1" size="10" value="0" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>                            
							<tr>
                                <td align='center'><input type="text" name="n_su1" size="3" value="<%=cnt1[0]%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt1" size="10" value="<%=Util.parseDecimal(amt1[0])%>" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>
                        </table>
                    </td>
                    <td class=line>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td class='title' colspan="2">연체미수금</td>
                            </tr>
                            <tr> 
                                <td class='title'  >건수</td>
                                <td class='title'  >금액</td>
                            </tr>
            			  <%	int  cnt2[]   = new int[8];
            			  		long amt2[]   = new long[8];
            					for(int j=0; j<8; j++){
            							cnt2[j]  += AddUtil.parseInt(String.valueOf(ht2.get("EST_SU"+j)));
            							amt2[j]  += AddUtil.parseLong(String.valueOf(ht2.get("EST_AMT"+j)));
            					}%>
            			  <%	for(int j=1; j<8; j++){%>
                            <tr>
                                <td align='center'><input type="text" name="n_su2" size="3" value="<%=cnt2[j]%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt2" size="10" value="<%=Util.parseDecimal(amt2[j])%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
            			  <%	}%>
                            <tr>
                                <td align='center'><input type="text" name="n_su2" size="3" value="<%=fee_size%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt2" size="10" value="<%=Util.parseDecimal(total_amt)%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                            <tr>
                                <td align='center'><input type="text" name="n_su2" size="3" value="<%=cnt2[0]+fee_size%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt2" size="10" value="<%=Util.parseDecimal(amt2[0]+total_amt)%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                        </table>
                    </td>
                    <td class=line>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td class='title' colspan="2">연체료</td>
                            </tr>
                            <tr> 
                                <td class='title'  >건수</td>
                                <td class='title'  >금액</td>
                            </tr>
        			  <%	int  cnt3[]   = new int[9];
        			  		long amt3[]   = new long[9];
        					for(int j=0; j<9; j++){
        							cnt3[j]  += AddUtil.parseInt(String.valueOf(ht3.get("EST_SU"+j)));
        							amt3[j]  += AddUtil.parseLong(String.valueOf(ht3.get("EST_AMT"+j)));
        					}%>
        			  <%	for(int j=1; j<8; j++){%>
                            <tr>
                                <td align='center'><input type="text" name="n_su3" size="3" value="<%if(j==2){%><%=cnt3[j]-cnt3[8]%><%}else{%><%=cnt3[j]%><%}%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt3" size="10" value="<%if(j==2){ //amt3[8]=fee_dly_pay_amt;%><%=Util.parseDecimal(amt3[j]-amt3[8])%><%}else{%><%=Util.parseDecimal(amt3[j])%><%}%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
        			  <%	}%>
                            <tr>
                                <td align='center'><input type="text" name="n_su3" size="3" value="0" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt3" size="10" value="0" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                            <tr>
                                <td align='center'><input type="text" name="n_su3" size="3" value="<%=cnt3[2]-cnt3[8]%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt3" size="10" value="<%=Util.parseDecimal(amt3[2]-amt3[8])%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                        </table>
                    </td>
                    <td class=line>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr>
                                <td class='title' colspan="2">
                				<%if(mode.equals("cont")){%>
                				<a href="javascript:credit_move();">대손처리</a>
                				<%}else{%>대손처리<%}%>
                				</td>
                            </tr>
                            <tr>
                                <td class='title'  >건수</td>
                                <td class='title'  >금액</td>
                            </tr>
            			  <%	int  cnt4[]   = new int[8];
            			  		long amt4[]   = new long[8];
            					for(int j=0; j<8; j++){
            							cnt4[j]  += AddUtil.parseInt(String.valueOf(ht4.get("EST_SU"+j)));
            							amt4[j]  += AddUtil.parseLong(String.valueOf(ht4.get("EST_AMT"+j)));
            					}%>
            			  <%	for(int j=1; j<8; j++){%>
                            <tr>
                                <td align='center'><input type="text" name="n_su4" size="3" value="<%=cnt4[j]%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt4" size="10" value="<%=Util.parseDecimal(amt4[j])%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
            			  <%	}%>
                            <tr>
                                <td align='center'><input type="text" name="n_su4" size="3" value="0" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt4" size="10" value="0" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                            <tr>
                                <td align='center'><input type="text" name="n_su4" size="3" value="<%=cnt4[0]%>" class="whitenum">
                      			건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt4" size="10" value="<%=Util.parseDecimal(amt4[0])%>" class="whitenum">
                      			원&nbsp; </td>
                            </tr>
                        </table>
                    </td>
                    <td class=line>
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr>
                                <td class='title' colspan="2">소계</td>
                            </tr>
                            <tr>
                                <td class='title'  >건수</td>
                                <td class='title'  >금액</td>
                            </tr>
            			    <%	for(int j=1; j<8; j++){%>
                            <tr>
                                <td align='center'><input type="text" name="n_su5" size="3" value="<%if(j==2){%><%=cnt1[j]+cnt2[j]+cnt3[j]+cnt4[j]-cnt3[8]%><%}else{%><%=cnt1[j]+cnt2[j]+cnt3[j]+cnt4[j]%><%}%>" class="whitenum">
                  			    건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt5" size="10" value="<%if(j==2){%><%=Util.parseDecimal(amt1[j]+amt2[j]+amt3[j]+amt4[j]-amt3[8])%><%}else{%><%=Util.parseDecimal(amt1[j]+amt2[j]+amt3[j]+amt4[j])%><%}%>" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>
            			  <%	}%>
                            <tr>
                                <td align='center'><input type="text" name="n_su5" size="3" value="<%=fee_size%>" class="whitenum">
                  			    건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt5" size="10" value="<%=Util.parseDecimal(total_amt)%>" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>
                            <tr>
                                <td align='center'><input type="text" name="n_su5" size="3" value="<%=cnt1[0]+cnt2[0]+cnt3[2]+cnt4[0]-cnt3[8]%>" class="whitenum">
                  			    건&nbsp;</td>
                                <td align='center'><input type="text" name="n_amt5" size="10" value="<%=Util.parseDecimal(amt1[0]+amt2[0]+amt3[2]+amt4[0]-amt3[8])%>" class="whitenum">
                  			    원&nbsp; </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width="17">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>	
    <tr> 
        <td colspan="2"> 
		<iframe src="/acar/settle_acc/fee_list_in.jsp?mode=<%=mode%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client_id%>&gubun2=<%=gubun2%>&today=<%=today%>&h_title=<%//=h_title%>" name="sub_in" width="100%" height=<%if(mode.equals("client")){%>"150"<%}else{%>"180"<%}%> cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</iframe> 
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
