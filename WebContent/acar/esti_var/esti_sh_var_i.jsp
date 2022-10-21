<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiShVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String sh_code = request.getParameter("sh_code")==null?"":request.getParameter("sh_code");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String disabled = "";
	if(!seq.equals("")) disabled = "disabled";
	
	//차종별잔가변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiShVarCase(sh_code, seq);
	
	//차종별 잔가변수 이력리스트
	Vector vt = e_db.getEstiShVarList(sh_code);
	int vt_size = vt.size();
	
	//차종별 특소세 리스트
	Vector vt2 = e_db.getSpTaxList(sh_code);
	int vt_size2 = vt2.size();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(fm.sh_code.value == ''){ alert('차종코드를 입력하십시오.'); return;}
		if(cmd == 'i'){
			if(!confirm('등록하시겠습니까?'))		{	return;	}
		}else if(cmd == 'add'){
			if(!confirm('추가하시겠습니까?'))		{	return;	}		
		}else if(cmd == 'u'){
			if(!confirm('수정하시겠습니까?'))		{	return;	}		
		}else if(cmd == 'd'){
			if(!confirm('삭제하시겠습니까?'))		{	return;	}		
		}else{
			if(!confirm('업그레이드하시겠습니까?'))	{	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form name="form1" method="post" action="esti_sh_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 견적변수관리 > <span class=style5>차종별잔가변수</span></span></td>
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
        <%if(!auth_rw.equals("1")){%>
        <%if(seq.equals("")){%>
        <a href="javascript:save('i');"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
        <%}else{%>
        <a href="javascript:save('u');"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
		<a href="javascript:save('up');"><img src=../images/center/button_upgrade.gif border=0 align=absmiddle></a>
		<a href="javascript:save('d');"><img src=../images/center/button_delete.gif border=0 align=absmiddle></a>		
        <%}%>
        <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=700>
                <tr>
                    <td width="120" class=title>차종코드</td>
                    <td width="580">&nbsp;<input name="sh_code" type="text" class=text id="sh_code" value="<%=bean.getSh_code()%>" size="15"></td>
                </tr>
                <tr>
                    <td class=title>차명</td>
                    <td>&nbsp;<input name="cars" type="text" class=text id="cars" value="<%=bean.getCars()%>" size="50"></td>
                </tr>
                <tr>
                    <td class=title>차량24개월잔가율</td>
                    <td>&nbsp;<input name="janga24" type="text" class=text id="janga24" value="<%=bean.getJanga24()%>" size="5">
                    %</td>
                </tr>
                <tr>
                    <td class=title>차종구분</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="25%">짚여부 :
                                  <input type="checkbox" name="jeep_yn" value="Y" <%if(bean.getJeep_yn().equals("Y"))%>checked<%%>></td>
                                <td width="30%">렌트(LPG)여부 :
                                  <input type="checkbox" name="rentcar" value="Y" <%if(bean.getRentcar().equals("Y"))%>checked<%%>></td>
                                <td width="45%">7~9인승여부 :
                                  <input type="checkbox" name="svn_nn_yn" value="Y" <%if(bean.getSvn_nn_yn().equals("Y"))%>checked<%%>></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=title>LPG 키트</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="25%"><span class="title">장착가능여부</span> :
                                  <input type="checkbox" name="lpg_ga_yn" value="Y" <%if(bean.getLpg_ga_yn().equals("Y"))%>checked<%%>></td>
                                <td width="30%">장/탈착비용 :
                                  <input type="text" name="lpg_amt" value='<%=AddUtil.parseDecimal(bean.getLpg_amt())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원</td>
                                <td width="45%">직접분사추가금액 :
                                  <input type="text" name="lpg_add_amt" value='<%=AddUtil.parseDecimal(bean.getLpg_add_amt())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=title>탁송료</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="25%">서울 :
                                  <input type="text" name="taksong_se" value='<%=AddUtil.parseDecimal(bean.getTaksong_se())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원</td>
                                <td width="30%">부산 :
                                  <input type="text" name="taksong_bu" value='<%=AddUtil.parseDecimal(bean.getTaksong_bu())%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                                원</td>
                                <td width="45%">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=title>할부이자율</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="25%"><span class="title">12/24개월</span> :
                                  <input name="af_m12_24" type="text" class=text value="<%=bean.getAf_m12_24()%>" size="5">
                                %</td>
                                <td width="30%"><span class="title">36개월</span> :
                                  <input name="af_m36" type="text" class=text value="<%=bean.getAf_m36()%>" size="5">
                                %</td>
                                <td width="45%"><span class="title">48/60개월</span> :
                                  <input name="af_m48_60" type="text" class=text value="<%=bean.getAf_m48_60()%>" size="5">
                                %</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=title>기준일자</td>
                    <td>&nbsp;<input type="text" name="reg_dt" value='<%=AddUtil.ChangeDate2(bean.getReg_dt())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>특소세</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=700>
                <tr>
                    <td width="310" class=title>적용기간</td>
                    <td width="320" class=title>특소세율</td>
                    <td width="80" class=title>-</td>
                </tr>
                <%	if(vt_size2 > 0){%>
                <%		for(int i = 0 ; i < vt_size2 ; i++){
        					Hashtable ht = (Hashtable)vt2.elementAt(i);%>
                <tr>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_ST_DT")))%> ~ <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_END_DT")))%></td>
                    <td align="center"><%=ht.get("SP_TAX")%>%</td>
                    <td align="center">&nbsp;</td>
                </tr>
                <%		}%>
                <tr><input type="hidden" name="sp_seq" value="<%=AddUtil.addZero2(vt_size2+1)%>">
                    <td align="center"><input type="text" name="tax_st_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>~<input type="text" name="tax_end_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td align="center"><input name="sp_tax" type="text" class=text value="" size="5">%</td>
                    <td align="center"><%if(vt_size > 0){%><%if(!auth_rw.equals("1")){%><a href="javascript:save('add');"><img src=../images/center/button_in_plus.gif border=0 align=absmiddle></a><%}%><%}%></td>
                </tr>
        		<%	}else{
        				//차종별 특소세 리스트
        				Vector vt3 = e_db.getSpTaxDtList(sh_code);
        				int vt_size3 = vt3.size();%>
                <%		for(int i = 0 ; i < vt_size3 ; i++){
        					Hashtable ht = (Hashtable)vt3.elementAt(i);%>
                <tr><input type="hidden" name="sp_seq" value="<%=AddUtil.addZero2(i+1)%>">
                    <td align="center"><input type="text" name="tax_st_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_ST_DT")))%>' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> ~ <input type="text" name="tax_end_dt" value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_END_DT")))%>' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td align="center"><input name="sp_tax" type="text" class=text value="" size="5">%</td>
                    <td align="center"></td>
                </tr>
        		<%		}%>
        		<%	}%>
            </table>
        </td>
    </tr>
<%	if(vt_size > 0){%>	
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>차종별 잔가변수 이력</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=700>
                <tr>
                    <td width="30" rowspan="2" class=title>연번</td>
                    <td width="50" rowspan="2" class=title>24개월<br>
                    잔가율</td>
                    <td width="40" rowspan="2" class=title>짚</td>
                    <td width="40" rowspan="2" class=title>렌트<br>
                    (LPG)</td>
                    <td width="40" rowspan="2" class=title>7~9<br>
                    인승</td>
                    <td colspan="3" class=title>LPG</td>
                    <td colspan="2" class=title>탁송료</td>
                    <td colspan="3" class=title>할부이자율</td>
                    <td width="80" rowspan="2" class=title>기준일자</td>
                </tr>
                <tr>
                    <td width="40" class=title>장착<br>
                    가능</td>
                    <td width="70" class=title>비용</td>
                    <td width="70" class=title>직접분사</td>
                    <td width="60" class=title>서울</td>
                    <td width="60" class=title>부산</td>
                    <td width="40" class=title>12/24</td>
                    <td width="40" class=title>35</td>
                    <td width="40" class=title>48/60</td>
                </tr>
        <%		for(int i = 0 ; i < vt_size ; i++){
        			Hashtable ht = (Hashtable)vt.elementAt(i);%>		
                <tr>
                    <td align="center"><%=i+1%></td>		
                    <td align="center"><%=ht.get("JANGA24")%>%</td>
                    <td align="center"><%=ht.get("JEEP_YN")%></td>
                    <td align="center"><%=ht.get("RENTCAR")%></td>
                    <td align="center"><%=ht.get("SVN_NN_YN")%></td>
                    <td align="center"><%=ht.get("LPG_GA_YN")%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_AMT")))%>원</td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_ADD_AMT")))%>원</td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_SE")))%>원</td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_BU")))%>원</td>
                    <td align="center"><%=ht.get("AF_M12_24")%>%</td>
                    <td align="center"><%=ht.get("AF_M36")%>%</td>
                    <td align="center"><%=ht.get("AF_M48_60")%>%</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                </tr>
        <%		}%>		
            </table>
        </td>
    </tr>
<%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>