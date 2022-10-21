<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode 	= request.getParameter("mode")==null?"dly_mm":request.getParameter("mode");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//계약기초
	ContBaseBean base = a_db.getContBase(m_id, l_cd);
	
	//고객정보
	ClientBean client = l_db.getClient(base.getClient_id());
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//하단페이지 보기
	function display_sc(st){
		var fm = document.form1;	
		fm.mode.value = st;
		
		if(st == 'sms_send'){
			window.open("/fms2/con_fee/credit_memo_sms.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&memo_st=<%=memo_st%>", "CREDIT_MEMO_SMS", "left=220, top=20, width=800, height=850");
		}else if(st == 'mgr_mng'){
			window.open("/agent/client/client_cont_cng.jsp?client_id=<%=client.getClient_id()%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>", "CREDIT_MGR_MNG", "left=250, top=50, width=1240, height=800");
		}else{
			fm.action = 'credit_memo_sc.jsp';
			fm.target = 'cm_foot';
			fm.submit();
		}
	}
	
	function display_cng(){
		var fm = document.form1;	
		if(fm.memo_st.value == 'client'){
			fm.memo_st.value = '';
		}else{
			fm.memo_st.value = 'client';		
		}
		fm.action = 'credit_memo_frame.jsp';
		fm.target = '_parent';
		fm.submit();	
	}	
	
	function search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == '1') fm.t_wd.value = fm.s_firm_nm.value;
		if(s_kd == '4') fm.t_wd.value = fm.s_rent_l_cd.value;
		if(fm.t_wd.value == ''){ alert('검색할 단어를 입력하십시오.'); return; }			
		window.open("about:blank", "SEARCH", "left=50, top=50, width=880, height=520, scrollbars=yes");				
		fm.action = "/tax/pop_search/s_cont.jsp";
		fm.target = "SEARCH";
		fm.submit();
	}	
	function enter(s_kd){
		var keyValue = event.keyCode;
		if (keyValue =='13') search(s_kd);
	}
	
	//업체별 과태료 청구문서
	function view_fine_doc(){
		window.open("/agent/account/fine_reqdoc_select.jsp?client_id=<%=base.getClient_id()%>&bus_id2=<%=base.getBus_id2()%>", "VIEW_FINE_DOC", "left=100, top=100, width=950, height=600, scrollbars=yes");	
	}
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>

<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='memo_st' value='<%=memo_st%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='go_url' value='/agent/con_fee/credit_memo_frame.jsp'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5><%if(memo_st.equals("client")){%>거래처 통합<%}else{%>계약(<%=l_cd%>)<%}%></span></span></td>	
                    <td class=bar align="right">&nbsp;<a href="javascript:display_cng()">[<%if(memo_st.equals("client")){%>계약(<%=l_cd%>)<%}else{%>거래처통합<%}%> 보기]</a></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='8%' class='title'>계약번호</td>
                    <td width='14%' align="center"><input type='text' name='s_rent_l_cd' value='<%=l_cd%>' size='15' class='text' onKeyDown='javascript:enter(4)' style='IME-MODE: inactive'></td>
                    <td width='8%' class='title'>상호</td>
                    <td width='34%' align="center"><input type='text' name='s_firm_nm' value='<%= client.getFirm_nm()%>' size='43' class='text' onKeyDown='javascript:enter(1)' style='IME-MODE: active'></td>
                    <td width='8%' class='title'>담당자</td>
                    <td width='10%' align="center"><%=c_db.getNameById((String)fee.get("BUS_ID2"), "USER")%></td>
                    <td width='8%' class='title'>채권유형</td>
                    <td width='10%' align="center"><%=fee.get("GI_ST")%></td>
                </tr>
                <tr>
                    <td class='title'>사무실</td>
                    <td align="center"><%= client.getO_tel()%></td>
                    <td class='title'>휴대폰</td>
                    <td align="center"><%= client.getM_tel()%></td>
                    <td class='title'>자택</td>
                    <td align="center"><%= client.getH_tel()%></td>
                    <td class='title'>팩스</td>
                    <td align="center"><%= client.getFax()%></td>
                </tr>
            </table>
	    </td>
	    <td width='16'>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td colspan=2 align="center">
		  <a href="javascript:display_sc('credit_doc')"><img src=/acar/images/center/button_p_bh_cgj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
          	  <a href="javascript:display_sc('cms_mm')"><img src=/acar/images/center/button_p_cmemo.gif align=absmiddle border=0></a>&nbsp;&nbsp;
          	  <a href="javascript:display_sc('dly_mm')"><img src=/acar/images/center/button_p_dmemo.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		</td>
    </tr>
</table>
</form>
</body>료
</html>
