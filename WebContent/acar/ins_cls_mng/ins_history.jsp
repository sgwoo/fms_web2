<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<%@ page import="acar.offls_sui.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = "5";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
		
	
	int total_amt1 = 0;
	int total_amt2 = 0;	
	
	if(!c_id.equals("") && m_id.equals("") && l_cd.equals("")){
		RentListBean bean = ai_db.getLongRentCase(c_id);
		m_id = bean.getRent_mng_id();
		l_cd = bean.getRent_l_cd();
	}	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//다른 보험으로 변경
	function move_ins(ins_st){	
		var fm = document.form1;	
		fm.mode.value = '';
		fm.ins_st.value = ins_st;
		fm.action = "ins_u_frame.jsp";		
		fm.target = "d_content";
		fm.submit();
	}
	
	//갱신
	function move_reg(){	
		var fm = document.form1;	
		fm.action = "../ins_reg/ins_reg_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}	
	//해지
	function move_cls(ins_st){	
		var fm = document.form1;
		fm.ins_st.value = ins_st;	
		fm.action = "../ins_cls/ins_cls_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
  <form action="ins_u_frame.jsp" name="form1">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='ins_st' value='<%=ins_st%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value=''>	
  </form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=13%><%=l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=21%><%=cont.get("FIRM_NM")%></td>
                    <td class=title width=10%>계약자</td>
                    <td width=12%><%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>사용본거지</td>
                    <td width=14%><%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td><%=cont.get("CAR_NO")%></td>
                    <td class=title>차명</td>
                    <td><%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>최초등록일</td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>차대번호</td>
                    <td><%=cont.get("CAR_NUM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약 이력 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width=6%>연번</td>
                  <td class=title width="9%">구분</td>
                  <td class=title width="15%%">계약번호</td>
                  <td class=title width="20%">상호</td>
                  <td class=title width="20%">대여기간</td>
                  <td class=title width="10%">대여구분</td>
                  <td class=title width="10%">대여방식</td>
                  <td class=title width="10%">해지일자</td>
                </tr>
                <%//계약이력
        			Vector rents = ai_db.getRentHisList(c_id);
        			int rent_size = rents.size();
        			if(rent_size > 0){		
        				for(int i = 0 ; i < rent_size ; i++){
        				Hashtable rent = (Hashtable)rents.elementAt(i);%>
                <tr> 
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=rent.get("USE_YN")%>
        		  <%if(!String.valueOf(rent.get("CLS_ST")).equals("")){%>
        		  (<%=rent.get("CLS_ST")%>)
        		  <%}%></td>
                  <td align="center"><%=rent.get("RENT_L_CD")%></td>
                  <td align="center"><%=rent.get("FIRM_NM")%></td>
                  <td align="center"><%=rent.get("RENT_START_DT")%>~<%=rent.get("RENT_END_DT")%></td>
                  <td align="center"><%=rent.get("CAR_ST")%></td>
                  <td align="center"><%=rent.get("RENT_WAY")%></td>
                  <td align="center"><%=rent.get("CLS_DT")%></td>
                </tr>
                <%		}%>
                <%	}%>
                <%	sBean = olsD.getSui(c_id);
        			if(!sBean.getMigr_dt().equals("")){%>
                <tr> 
                  <td class=title>연번</td>
                  <td class=title>구분</td>
                  <td class=title>-</td>
                  <td class=title>계약자</td>
                  <td class=title>연락처</td>
                  <td class=title>계약일자</td>
                  <td class=title>매매대금</td>
                  <td class=title>명의이전일</td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">명의이전</td>
                  <td align="center">-</td>
                  <td align="center"><%=sBean.getSui_nm()%></td>
                  <td align="center"><%=sBean.getH_tel()%>,<%=sBean.getM_tel()%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
                  <td align="center"><%=AddUtil.parseDecimal(sBean.getMm_pr())%>원</td>
                  <td align="center"><%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <%		//용도변경 이력
			Vector cngs = ai_db.getCarNoCng(c_id);
			int cng_size = cngs.size();
			if(cng_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용도변경 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <%     		for(int i = 0 ; i < cng_size ; i++){
        					Hashtable cng = (Hashtable)cngs.elementAt(i);
        					String cha_cau = String.valueOf(cng.get("CHA_CAU"));%>
                <tr> 
                  <td class=title width=10%>변경일자</td>
                  <td width=13%><%=AddUtil.ChangeDate2(String.valueOf(cng.get("CHA_DT")))%></td>
                  <td class=title width=10%>변경사유</td>
                  <td width=21%> 
                    <%if(cha_cau.equals("1")){%>
                    사용본거지 변경 
                    <%}else if(cha_cau.equals("2")){%>
                    용도변경 
                    <%}else if(cha_cau.equals("3")){%>
                    기타 
                    <%}else if(cha_cau.equals("4")){%>
                    없음 
                    <%}else if(cha_cau.equals("5")){%>
                    신규등록 
                    <%}%>
                  </td>
                  <td class=title width=10%>변경내용</td>
                  <td width=36%><%=cng.get("CHA_CAU_SUB")%> </td>
                </tr>
                <%			}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
  <%	}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험 이력 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="6%">연번</td>
                  <td class=title width="8%">구분</td>
                  <td class=title width="8%">보험종류</td>
                  <td class=title width="8%">보험사명</td>
                  <td class=title width="20%">보험기간</td>
                  <td class=title width="13%">보험료</td>
                  <td class=title width="13%">환급금액</td>
                  <td class=title width="16%">등록/해지사유</td>
                  <td class=title width="8%">해지</td>
                </tr>
                <%//보험이력-일반보험
        			Vector inss2 = ai_db.getInsHisList1(c_id);
        			int ins_size2 = inss2.size();
        			if(ins_size2 > 0){
                		for(int i = 0 ; i < ins_size2 ; i++){
        				Hashtable ins2 = (Hashtable)inss2.elementAt(i);%>
                <tr> 
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=ins2.get("INS_STS")%></td>
                  <td align="center"><%=ins2.get("GUBUN")%></td>
                  <td align="center"><%=ins2.get("INS_COM_NM")%></td>
                  <td align="center"><%=ins2.get("INS_START_DT")%>~<%=ins2.get("INS_EXP_DT")%></td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(ins2.get("INS_AMT")))%>원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(ins2.get("RTN_AMT")))%>원&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td>&nbsp;<%=ins2.get("REG_CAU")%>&nbsp;<%=ins2.get("EXP_CAU")%></td>
                  <td align="center"><a href="javascript:move_cls('<%=ins2.get("INS_ST")%>')"><img src="/acar/images/center/button_in_hj.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}%>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>