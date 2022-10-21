<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.* "%>
<%@ page import="acar.settle_acc.*, acar.cls.*, acar.fee.*, acar.cont.*,acar.client.*, acar.credit.*, acar.doc_settle.*, acar.ext.*, acar.res_search.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="acr_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String page_st = request.getParameter("page_st")==null?"":request.getParameter("page_st");
	
	String cls_use_mon 	= request.getParameter("cls_use_mon")==null?"":request.getParameter("cls_use_mon");
	String bad_amt 		= request.getParameter("bad_amt")==null?"":request.getParameter("bad_amt");
	int    seq		= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String doc_no 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String use_end_dt = "";
	String accid_id = "";
	String serv_id = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
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
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//업체정보
	ClientBean client = al_db.getClient(client_id);
	
	//해지의뢰정보
	ClsEtcBean cls_etc = acr_db.getClsEtcCase(m_id, l_cd);
	
	//해지의뢰상계정보
	ClsEtcSubBean cls_etc_sub = acr_db.getClsEtcSubCase(m_id, l_cd, 1);
	
	RentContBean 	rc_bean 	= new RentContBean();
	RentCustBean 	rc_bean2 	= new RentCustBean();
	RentFeeBean 	rf_bean 	= new RentFeeBean();
	RentSettleBean 	rs_bean 	= new RentSettleBean();
	Hashtable 	reserv 		= new Hashtable();
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
		
	
	//예약시스템(월렌트)
	if(!s_cd.equals("")){
	
		
		//차량정보
		reserv = rs_db.getCarInfo(c_id);
		//단기계약정보
		rc_bean = rs_db.getRentContCase(s_cd, c_id);
		//고객정보
		rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
		//단기대여정보
		rf_bean = rs_db.getRentFeeCase(s_cd);
		//단기대여정산정보
		rs_bean = rs_db.getRentSettleCase(s_cd);
		
		if(rc_bean.getRent_st().equals("12")){
			m_id 	= c_id;
			l_cd 	= "RM00000"+s_cd;
			client_id = rc_bean.getCust_id();
		}
					
	}
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("46", l_cd+""+String.valueOf(seq));
	if(doc_no.equals("")){
		doc_no = doc.getDoc_no();
	}
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//요청내용 및 처리구분 관리
	BadDebtReqBean bad_debt = a_db.getBadDebtReq(m_id, l_cd, seq);
	
	//대손처리요청리스트
	Vector item_vt = a_db.getBadDebtReqItemList(doc.getDoc_id());
	int item_vt_size = item_vt.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 20; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	//계약기본정보
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//계약승계 혹은 차종변경일때 승계계약 해지내용
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	
	long total_amt 	= 0;
	long total_s_amt 	= 0;
	long total_v_amt 	= 0;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		<%if(page_st.equals("settle_acc")){%>	
		fm.action = '/acar/settle_acc/settle_s_frame.jsp';		
		<%}else{%>
		fm.action = '/fms2/settle_acc/bad_debt_doc_frame.jsp';		
		<%}%>	
		fm.mode.value = '';
		fm.target = 'd_content';	
		fm.submit();
	}	
	
	//고객 보기
	function view_client(){
		var m_id = document.form1.m_id.value;		
		var l_cd = document.form1.l_cd.value;			
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
	//결재하기
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '1'){
			if(fm.bad_debt_cau.value == '')	{ alert('요청사유를 입력하십시오.'); 				return; }
		}else if(doc_bit == '2'){
			if(fm.bad_debt_st.value == '')	{ alert('처리구분을 선택하십시오.'); 				return; }		
		}
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='bad_debt_doc_sanction.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}									
	}
	
	//담당자 변경하기
	function bad_debt_busid2_cng(){
		var fm = document.form1;
		
		if(confirm('변경하시겠습니까?')){	
			fm.action='bad_debt_busid2_cng_a.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}							
	}
	
	//대손처리하기
	function bad_debt_dir_action(){
		var fm = document.form1;
		
		if(confirm('처리하시겠습니까?')){	
			fm.action='bad_debt_dir_action_a.jsp';		
			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}				
	}
	
	//기각일대 사유보이기
	function display_reject(){
		var fm = document.form1;
		
		if(fm.bad_debt_st.value =='3'){ //기각
			tr_reject.style.display	= '';
		}else{							//승인
			tr_reject.style.display	= 'none';
		}
	}
	
	function view_memo()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;		
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var r_st = '1';						
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750");		
	}	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}		
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='bad_debt_doc_sanction.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
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
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='seq' 		value='<%=seq%>'>
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">
<input type='hidden' name="doc_bit" 	value="">
<input type='hidden' name="car_no" 		value="<%=ht.get("CAR_NO")%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 미수금정산 관리 > <span class=style5>채권 대손처리 요청</span></span></td>
					<td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>[계약승계] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[계약승계] 승계계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 승계일자 : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, 해지일자 : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[차종변경] 변경계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 변경일자 : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align='right'><a href='javascript:go_to_list()'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    <a href='javascript:history.go(-1);'><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a>	  
	    </td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(m_id.equals(c_id) && !s_cd.equals("")){%>
                <input type='hidden' name="firm_nm" 	value="<%=rc_bean2.getFirm_nm()%>">
                <tr> 
                    <td width=10% class='title'>계약번호</td>
                    <td width=23%>&nbsp;<%=rc_bean.getRent_s_cd()%>
                        <%if(rc_bean.getRent_st().equals("1")){%>
                    단기대여 
                    <%}else if(rc_bean.getRent_st().equals("2")){%>
                    정비대차 
                    <%}else if(rc_bean.getRent_st().equals("3")){%>
                    사고대차 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    보험대차 		
                    <%}else if(rc_bean.getRent_st().equals("10")){%>
                    지연대차 				
                    <%}else if(rc_bean.getRent_st().equals("4")){%>
                    업무대여 
                    <%}else if(rc_bean.getRent_st().equals("5")){%>
                    업무지원 
                    <%}else if(rc_bean.getRent_st().equals("6")){%>
                    차량정비 
                    <%}else if(rc_bean.getRent_st().equals("7")){%>
                    차량점검 
                    <%}else if(rc_bean.getRent_st().equals("8")){%>
                    사고수리 
                    <%}else if(rc_bean.getRent_st().equals("11")){%>
                    기타 
                    <%}else if(rc_bean.getRent_st().equals("12")){%>
                    월렌트
                    <%}%>
                    </td>
                    <td width=10% class='title'>영업담당자</td>
                    <td width=23%>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
                    <td width=10% class='title'>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getMng_id(),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=reserv.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                    <td class='title'>등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                </tr>  
                <tr> 
                    <td class='title'>상호</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class='title'>고객명</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class='title'>반차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                    <td class='title'>총사용기간</td>
                    <td>&nbsp;<%=rs_bean.getTot_months()%>개월<%=rs_bean.getTot_days()%>일</td>
                </tr>       						                                          
                <%}else{%>
                <input type='hidden' name="firm_nm" 	value="<%=ht.get("FIRM_NM")%>">
                <tr> 
                    <td class='title'>계약번호</td>
                    <td>&nbsp;<%=ht.get("RENT_L_CD")%></td>
                    <td class='title'>영업담당자</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("BUS_ID2")),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=m_id%>', '<%=l_cd%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a></td>
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
		<%if(!String.valueOf(ht.get("CLS_DT")).equals("")){%>
                <tr> 
                    <td class='title'>해지일자 </td>
                    <td> &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%> 
						<%if(!cls_use_mon.equals("")){%>
						[해지경과월:<%=cls_use_mon%>개월]
						<%}%>
					</td>
                    <td class='title'>해지구분 </td>
                    <td> &nbsp;<%=ht.get("CLS_ST_NM")%></td>
                    <td class='title'>해지사유</td>
                    <td colspan="3"> &nbsp;<%=ht.get("CLS_CAU")%> </td>
                </tr>
		<%}%>
                <%}%>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미수 채권 </span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class='title'>연번</td>								
                    <td width=10% class='title'>구분</td>				
                    <td width=10% class='title'>입금예정일</td>
                    <td width=10% class='title'>공급가</td>
                    <td width=10% class='title'>부가세</td>
                    <td width=10% class='title'>합계</td>
                    <td width=45% class='title'>비고</td>									
                </tr>	
<% int count = 0;%>		



<%if(doc.getDoc_id().equals("")){%>


<%
	//선수금리스트
	Vector pre_lists = s_db.getPreList(m_id, l_cd, client_id, mode, gubun2, today);
	int pre_size = pre_lists.size();
	if(pre_size > 0){
		for (int i = 0 ; i < pre_size ; i++){
			Hashtable item_ht = (Hashtable)pre_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
					<td align="center"><%=item_ht.get("ST")%>  <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>										
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>
                    <td>&nbsp;
					<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1") && !String.valueOf(item_ht.get("ST")).equals("승계수수료")){
							//신차대여정보
							ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, String.valueOf(item_ht.get("RENT_ST")));
							int ext_base_amt = 0;
							if(String.valueOf(item_ht.get("ST")).equals("보증금")){
								ext_base_amt = fee.getGrt_amt_s();
							}else if(String.valueOf(item_ht.get("ST")).equals("선납금")){
								ext_base_amt = fee.getPp_s_amt()+fee.getPp_v_amt();
							}else if(String.valueOf(item_ht.get("ST")).equals("개시대여료")){
								ext_base_amt = fee.getIfee_s_amt()+fee.getIfee_v_amt();
							}
						%>
						<input type='hidden' name='etc' value='총금액 <%=AddUtil.parseDecimal(ext_base_amt)%>원중 <%=Util.parseDecimal(ext_base_amt-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금'>
						<font color=green>총금액 <%=AddUtil.parseDecimal(ext_base_amt)%>원중 <%=Util.parseDecimal(ext_base_amt-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금</font>
					<%}else{%>
						<input type='hidden' name='etc' value=''>
					<%}%>
					</td>
                </tr>
<%		}
	}%>	
	
<%	if(String.valueOf(ht.get("CLS_ST_NM")).equals("계약승계")){%>
<%		//대여료리스트
		Vector fee_lists = s_db.getFeeList(m_id, l_cd, client_id, mode, gubun2, today);
		int fee_size = fee_lists.size();
		if(fee_size > 0){
			for (int i = 0 ; i < fee_size ; i++){
				Hashtable item_ht = (Hashtable)fee_lists.elementAt(i);
				count++;
			
				total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
				total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
				total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("RENT_SEQ")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("TM_ST1")%>'>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
					<td align="center"><%=item_ht.get("ST")%>  <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>										
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>
                    <td>&nbsp;<input type='hidden' name='etc' value=''></td>
                </tr>
<%			}
		}%>
<%		//연체이자
		Vector fee_dly_lists = s_db.getFeeDlyList(m_id, l_cd, client_id, mode, gubun2, today);
		int fee_dly_size = fee_dly_lists.size();
		
		
		if(fee_dly_size > 0){
			for (int i = 0 ; i < fee_dly_size; i++){
				Hashtable item_ht = (Hashtable)fee_dly_lists.elementAt(i);
				count++;
			
				total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("DLY_AMT")));				
				total_amt   = total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("DLY_AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ST")%>'>
				<input type='hidden' name='item_cd1' value=''>
				<input type='hidden' name='item_cd2' value=''>
				<input type='hidden' name='item_cd3' value=''>
				<input type='hidden' name='item_cd4' value=''>
				<input type='hidden' name='item_cd5' value=''>
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value=''>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("DLY_AMT")%>'>
				<input type='hidden' name='v_amt' value='0'>
				<input type='hidden' name='amt' value='<%=item_ht.get("DLY_AMT")%>'>
                <tr> 
                    <td align="center"><%=count%></td>
		    <td align="center"><%=item_ht.get("ST")%></td>
                    <td align="center"></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("DLY_AMT")))%>원</td>
                    <td align="right">0원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("DLY_AMT")))%>원</td>
                    <td>&nbsp;<input type='hidden' name='etc' value=''></td>
                </tr>
<%			}
		}%>		
	
<%	}%>



<%
	//과태료리스트
	Vector fine_lists = s_db.getFineList(m_id, l_cd, client_id, mode, gubun2, today);
	int fine_size = fine_lists.size();
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			Hashtable item_ht = (Hashtable)fine_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>			
				<input type='hidden' name='item_gubun' value='과태료'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("SEQ_NO")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("RENT_L_CD")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
				    <td align="center">과태료 <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/fine_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=item_ht.get("SEQ_NO")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>	
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>
                    <td align="right"></td>														
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>
                    <td>&nbsp;[<%=item_ht.get("ST")%>] 청구기관:<%=item_ht.get("GOV_NM")%> | 위반장소:<%=item_ht.get("VIO_PLA")%><br>&nbsp;위반일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("VIO_DT")))%> | 납부일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("PROXY_DT")))%> | 청구일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("DEM_DT")))%>
					<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] 청구기관:<%=item_ht.get("GOV_NM")%> | 위반장소:<%=item_ht.get("VIO_PLA")%><br>&nbsp;위반일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("VIO_DT")))%> | 납부일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("PROXY_DT")))%> | 청구일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("DEM_DT")))%>'>
					</td>					
                </tr>
<%		}
	}%>		
			
<%
	//중도해지위약금리스트
	Vector cls_lists = s_db.getClsList(m_id, l_cd, client_id, mode, gubun2, today);
	int cls_size = cls_lists.size();
	
	if(cls_size > 0){
		for (int i = 0 ; i < cls_size ; i++){
			Hashtable item_ht = (Hashtable)cls_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>			
				<input type='hidden' name='item_gubun' value='해지정산금'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">해지정산금 <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/cls_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> 
					</td>				
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>
                    <td>
						<%if(i==0){%>
							<table width="100%" border="0">
								<%if(String.valueOf(item_ht.get("ST")).equals("잔액")){%>
								<tr>
									<td colspan='3'><font color=green>총금액 <%=AddUtil.parseDecimal(cls_etc.getFdft_amt2())%>원중 <%=Util.parseDecimal(cls_etc.getFdft_amt2()-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금</font>
									<input type='hidden' name='etc' value='총금액 <%=AddUtil.parseDecimal(cls_etc.getFdft_amt2())%>원중 <%=Util.parseDecimal(cls_etc.getFdft_amt2()-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금'>
									</td>
								</tr>
								<%}else{%>
								<input type='hidden' name='etc' value=''>
								<%}%>
							</table>												
						<%}else{%>
						<input type='hidden' name='etc' value=''>
						<%}%>
					</td>					
                </tr>
<%		}
	}%>		
	
	
<%
	//면책금리스트
	Vector serv_lists = s_db.getServList(m_id, l_cd, client_id, mode, gubun2, today);
	int serv_size = serv_lists.size();
	if(serv_size > 0){
		for (int i = 0 ; i < serv_size ; i++){
			Hashtable item_ht = (Hashtable)serv_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='면책금'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value='<%=item_ht.get("ACCID_ID")%>'>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>

                <tr> 
                    <td align="center"><%=count%></td>								
				    <td align="center">면책금 <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c7.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&serv_id=<%=item_ht.get("SERV_ID")%>&accid_id=<%=item_ht.get("ACCID_ID")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>										
                    <td>&nbsp;
						<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1")){%>
								<font color=green>총금액 <%=Util.parseDecimal(String.valueOf(item_ht.get("CUST_AMT")))%>원중 <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("CUST_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금</font>
								<input type='hidden' name='etc' value='총금액 <%=Util.parseDecimal(String.valueOf(item_ht.get("CUST_AMT")))%>원중 <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("CUST_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금'>
						<%}else{%>
					    [<%=item_ht.get("ST")%>] 정비업체:<%=item_ht.get("OFF_NM")%> | 정비일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("SERV_DT")))%> | 정비금액:<%=Util.parseDecimal(String.valueOf(item_ht.get("REP_AMT")))%>원
						<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] 정비업체:<%=item_ht.get("OFF_NM")%> | 정비일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("SERV_DT")))%> | 정비금액:<%=Util.parseDecimal(String.valueOf(item_ht.get("REP_AMT")))%>원'>
						<%}%>
					</td>
                </tr>
<%		}
	}%>		

	

<!--	
	
<%
	//휴/대차료 리스트
	Vector accid_lists = s_db.getAccidList(m_id, l_cd, client_id, mode, gubun2, today);
	int accid_size = accid_lists.size();
	if(accid_size > 0){
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable item_ht = (Hashtable)accid_lists.elementAt(i);
			count++;
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>				  
				<input type='hidden' name='item_gubun' value='대차료'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("EXT_ST")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("EXT_TM")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("EXT_ID")%>'>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>

                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">대차료 <a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c8.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=item_ht.get("SEQ_NO")%>&accid_id=<%=item_ht.get("ACCID_ID")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>										
                    <td>&nbsp;
						<%if(!String.valueOf(item_ht.get("EXT_TM")).equals("1")){%>
								<font color=green>총금액 <%=Util.parseDecimal(String.valueOf(item_ht.get("REQ_AMT")))%>원중 <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("REQ_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금</font>
								<input type='hidden' name='etc' value='총금액 <%=Util.parseDecimal(String.valueOf(item_ht.get("REQ_AMT")))%>원중 <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(item_ht.get("REQ_AMT")))-AddUtil.parseInt(String.valueOf(item_ht.get("AMT"))))%>원 입금'>	
						<%}else{%>
					    		[<%=item_ht.get("ST")%>] 보험사:<%=item_ht.get("OT_INS")%> | 사고일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("ACCID_DT")))%> | 청구일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("REQ_DT")))%>
						<input type='hidden' name='etc' value='[<%=item_ht.get("ST")%>] 보험사:<%=item_ht.get("OT_INS")%> | 사고일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("ACCID_DT")))%> | 청구일자:<%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("REQ_DT")))%>'>	
						<%}%>
					</td>
                </tr>
<%		}
	}%>	
	
-->	
	
<%
	//월렌트정산금
	if(m_id.equals(c_id) && !s_cd.equals("")){
		Vector res_lists = s_db.getRentCont12List(c_id, s_cd, rc_bean.getCust_id(), mode, gubun2, today);
		int res_size = res_lists.size();
	
		if(res_size > 0){
			for (int i = 0 ; i < res_size ; i++){
				Hashtable item_ht = (Hashtable)res_lists.elementAt(i);
				count++;
			
				total_s_amt 	= total_s_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_S_AMT")));
				total_v_amt 	= total_v_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_V_AMT")));
				total_amt 	= total_amt 	+ AddUtil.parseLong(String.valueOf(item_ht.get("RENT_AMT")));
%>			
				<input type='hidden' name='item_gubun' value='월렌트정산금'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("RENT_ST")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("TM")%>'>
				<input type='hidden' name='item_cd3' value=''>
				<input type='hidden' name='item_cd4' value=''>
				<input type='hidden' name='item_cd5' value=''>								
				<input type='hidden' name='item_seq' value='<%=count%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("RENT_S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("RENT_V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("RENT_AMT")%>'>
				<input type='hidden' name='etc' value=''>
	  
                <tr> 
                    <td align="center"><%=count%></td>								
                    <td align="center">월렌트정산금 <a class=index1 href="javascript:MM_openBrWindow('/acar/con_rent/res_fee_c.jsp?mode=view&c_id=<%=c_id%>&s_cd=<%=s_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a> 
					</td>				
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("RENT_AMT")))%>원</td>
                    <td>&nbsp;</td>					
                </tr>
<%			}
		}
	}%>				
	
<%}else{//소액채권 항목 리스트%>	


<%	count = item_vt_size; %>

<%
		for(int i = 0 ; i < item_vt_size ; i++)
		{
			Hashtable item_ht = (Hashtable)item_vt.elementAt(i);
			
			total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(item_ht.get("S_AMT")));
			total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(item_ht.get("V_AMT")));
			total_amt 	= total_amt + AddUtil.parseLong(String.valueOf(item_ht.get("AMT")));
%>

				<input type='hidden' name='item_gubun' value='<%=item_ht.get("ITEM_GUBUN")%>'>
				<input type='hidden' name='item_cd1' value='<%=item_ht.get("ITEM_CD1")%>'>
				<input type='hidden' name='item_cd2' value='<%=item_ht.get("ITEM_CD2")%>'>
				<input type='hidden' name='item_cd3' value='<%=item_ht.get("ITEM_CD3")%>'>
				<input type='hidden' name='item_cd4' value='<%=item_ht.get("ITEM_CD4")%>'>
				<input type='hidden' name='item_cd5' value='<%=item_ht.get("ITEM_CD5")%>'>								
				<input type='hidden' name='item_seq' value='<%=item_ht.get("SEQ")%>'>
				<input type='hidden' name='est_dt' value='<%=item_ht.get("EST_DT")%>'>
				<input type='hidden' name='s_amt' value='<%=item_ht.get("S_AMT")%>'>
				<input type='hidden' name='v_amt' value='<%=item_ht.get("V_AMT")%>'>
				<input type='hidden' name='amt' value='<%=item_ht.get("AMT")%>'>
				<input type='hidden' name='etc' value='<%=item_ht.get("ETC")%>'>

                <tr> 
                    <td align="center"><%=item_ht.get("SEQ")%></td>								
                    <td align="center"><%=item_ht.get("ITEM_GUBUN")%>
						<%if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("보증금")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("선납금")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("개시대여료")||String.valueOf(item_ht.get("ITEM_GUBUN")).equals("승계수수료")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/grt_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("과태료")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/fine_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=item_ht.get("ITEM_CD1")%>&seq_no=<%=item_ht.get("ITEM_CD2")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("해지정산금")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/cls_c.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("면책금")){%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c7.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&serv_id=<%=item_ht.get("ITEM_CD4")%>&accid_id=<%=item_ht.get("ITEM_CD5")%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("대차료")){
								String i_accid_id = String.valueOf(item_ht.get("ITEM_CD4")).substring(0, 6);
								String i_seq_no   = String.valueOf(item_ht.get("ITEM_CD4")).substring(6);
								%>
							<a class=index1 href="javascript:MM_openBrWindow('/fms2/settle_acc/accid_c8.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=i_seq_no%>&accid_id=<%=i_accid_id%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}else if(String.valueOf(item_ht.get("ITEM_GUBUN")).equals("월렌트정산금")){%>
						        <a class=index1 href="javascript:MM_openBrWindow('/acar/con_rent/res_fee_c.jsp?mode=view&c_id=<%=c_id%>&s_cd=<%=s_cd%>','popwin_fine','scrollbars=yes,status=yes,resizable=yes,width=850,height=570,left=100, top=100')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a>
						<%}%>
					</td>		
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(item_ht.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("S_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("V_AMT")))%>원</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(item_ht.get("AMT")))%>원</td>										
                    <td>&nbsp;<%=item_ht.get("ETC")%></td>
                </tr>

<%		}%>

<%}%>
			
                <tr> 
                    <td class="title" colspan="3">합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_s_amt)%>원</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_v_amt)%>원</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원
					<input type='hidden' name="bad_amt" 		value="<%=total_amt%>">
					</td>													
                    <td class="title">&nbsp;</td>
                </tr>					  
            </table>
        </td>
    </tr>
    <tr>
        <td>* 구분 옆에 이는 <img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0">를 클릭하면 상세내역 확인 가능합니다.</td>
    </tr>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대손처리요청</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">요청사유</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="bad_debt_cau"><%=bad_debt.getBad_debt_cau()%></textarea></td>
                </tr>		
				<%if(!doc.getUser_dt1().equals("")){%>		
                <tr> 
                    <td class='title' width="10%">처리구분</td>
                    <td>&nbsp;
                      <select name='bad_debt_st'  class='default' <%if(!doc.getUser_dt1().equals("")){%>onchange="javascript:display_reject();"<%}%> <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">선택</option>
						<option value="1" <%if(bad_debt.getBad_debt_st().equals("1"))%>selected<%%>>승인(채권추심)</option>
						<option value="2" <%if(bad_debt.getBad_debt_st().equals("2")||bad_debt.getBad_debt_st().equals(""))%>selected<%%>>승인(대손처리)</option>
						<option value="3" <%if(bad_debt.getBad_debt_st().equals("3"))%>selected<%%>>기각</option>
                      </select>
					</td>
                </tr>				
                <tr id=tr_reject style="display:<%if(bad_debt.getBad_debt_st().equals("3")){%>''<%}else{%>none<%}%>"> 
                    <td class='title' width="10%">기각사유</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=bad_debt.getReject_cau()%></textarea></td>
                </tr>								
				<%}%>
           </table>
        </td>
    </tr>	
	<%if(!doc.getUser_dt2().equals("") && !bad_debt.getBad_debt_st().equals("3")){%>			
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td ><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>처리결과</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<%		if(bad_debt.getBad_debt_st().equals("1")){//채권추심%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">채권추심</td>
                    <td>&nbsp;
                      <%=c_db.getNameById(bad_debt.getOld_bus_id2(),"USER")%> --> <%=c_db.getNameById(bad_debt.getNew_bus_id2(),"USER")%>
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  <%if(bad_debt.getBus_id2_cng_yn().equals("Y")){//변경완료%>
					  [변경완료] <%=bad_debt.getCng_dt()%> <%=c_db.getNameById(bad_debt.getCng_id(),"USER")%>
					  <%}else{%>
					  <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)){%>
					  <a href="javascript:bad_debt_busid2_cng()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					  <%	}else{%>
					  변경되지 않았습니다.
					  <%	}%>
					  <%}%>
					</td>
                </tr>				
           </table>
        </td>
    </tr>		
	<%		}%>			
	<%		if(bad_debt.getBad_debt_st().equals("2")){//대손처리%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">대손처리</td>
                    <td>&nbsp;
					  <%if(bad_debt.getBus_id2_cng_yn().equals("Y")){//변경완료%>
					  [처리완료] <%=bad_debt.getCng_dt()%> <%=c_db.getNameById(bad_debt.getCng_id(),"USER")%>
					  <%}else{%>
					  <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)){%>
					  <a href="javascript:bad_debt_dir_action()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					  <%	}else{%>
					  처리되지 않았습니다.
					  <%	}%>
					  <%}%>
					</td>
                </tr>				
           </table>
        </td>
    </tr>		
	<%		}%>					
	<%}%>				
    <tr>
        <td class=h></td>
    </tr>				
    <tr> 
        <td width="right" align="right">&nbsp;<a href="javascript:view_memo()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_tel.gif align=absmiddle border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=20%>지점명</td>					
                    <td class=title width=20%>기안자</td>
                    <td class=title width=20%>총무팀장</td>
                    <td class=title width=30%>-</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("") && count>0 ){%><br><a href="javascript:doc_sanction('1');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td>
                * doc_no : [<%=doc_no%>]
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
