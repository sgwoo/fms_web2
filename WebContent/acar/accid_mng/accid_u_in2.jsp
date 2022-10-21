<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.user_mng.*, acar.insur.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"2":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	
	//보험정보
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	if(a_bean.getOur_ins().equals("")) a_bean.setOur_ins(ins_com_nm);
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(gubun, cmd, idx){
		var fm = document.form1;	
		fm.idx2.value = idx;
		fm.cmd.value = cmd;
		fm.gubun.value = gubun;
		
		
		
		if(cmd == 'u'){
			if(!confirm('수정하시겠습니까?')){	return;	}
		}else{
			if(!confirm('등록하시겠습니까?')){	return;	}		
		}		
		fm.target = "i_no"
		
		fm.submit();
	}
	
	function add_display(){
		var fm = document.form1;	
		if(fm.add_chk.value == 'N'){
			fm.add_chk.value = 'Y';
			tr1.style.display = '';
			tr2.style.display = '';			
		}else{
			fm.add_chk.value = 'N';
			tr1.style.display = 'none';
			tr2.style.display = 'none';			
		}
	}
	
	//보험사조회
	function find_gov_search(idx){
		var fm = document.form1;	
		window.open("find_gov_search.jsp?mode=<%=mode%>&idx="+idx, "SEARCH_FINE_INSCOM", "left=100, top=10, width=1050, height=850, scrollbars=yes");
	}		
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='our_car_nm' value='<%=cont.get("CAR_NM")%>'>
    <input type='hidden' name='size' value='<%=oa_r.length%>'>
    <input type='hidden' name='gubun' value=''>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='idx2' value=''>		
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
	<input type='hidden' name='add_chk' value='N'>		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>인적사항</span></td>
        <td align="right">&nbsp; </td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;<font color=red>1. 당사차량</font></td>
        <td align="right"> 
        
         <%	if( nm_db.getWorkAuthUser("전산팀",user_id)  ||nm_db.getWorkAuthUser("본사관리팀장",user_id) ){%> 
	        <a href="javascript:save('our', 'u', '')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
	     <%	} else { %>	     
		     <%	if(a_bean.getSettle_st().equals("0")){%>
		        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		        <a href="javascript:save('our', 'u', '')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
		        <%	}%>	   
		     <% } %>   	     
        <%  } %>      
            
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="2" width=8%>운전자</td>
                    <td class=title width=9%>운전자명</td>
                    <td width=14%> 
                      <input type="text" name="our_driver" value="<%=a_bean.getOur_driver()%>" size="15" class=text style='IME-MODE: active' maxlength="10">
                    </td>
                    <td class=title width=9%>생년월일</td>
                    <td width=14%> 
                      <input type="text" name="our_ssn" value="<%=AddUtil.ChangeSsn(a_bean.getOur_ssn())%>" size="15" class=text maxlength="8">
                    </td>
                    <td class=title width=9%>면허번호</td>
                    <td width=14%> 
                      
                      <input type="text" name="our_lic_no" value="<%=a_bean.getOur_lic_no()%>" size="15" class=text maxlength="16" >
                    </td>
                    <td class=title width=9%>면허종별</td>
                    <td width=14%> 
                      <input type="text" name="our_lic_kd" value="<%=a_bean.getOur_lic_kd()%>" size="15" class=text maxlength="10" >
                    </td>
                </tr>
                <tr> 
                    <td class=title>면허유효기간</td>
                    <td> 
                      <input type="text" name="our_lic_dt" value="<%=AddUtil.ChangeDate2(a_bean.getOur_lic_dt())%>" size="15" class=text  onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
                    </td>
                    <td class=title>휴대폰</td>
                    <td> 
                      <input type="text" name="our_m_tel" value="<%=a_bean.getOur_m_tel()%>" size="15" class=text maxlength="15">
                    </td>
                    <td class=title>연락처Ⅰ</td>
                    <td> 
                      <input type="text" name="our_tel" value="<%=a_bean.getOur_tel()%>" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>연락처Ⅱ</td>
                    <td> 
                      <input type="text" name="our_tel2" value="<%=a_bean.getOur_tel2()%>" size="15" class=text maxlength="15" >
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">보험사</td>
                    <td class=title>보험사명</td>
                    <td> 					  
                      <input type="text" name="our_ins" value="<%=a_bean.getOur_ins()%>" size="15" class=text maxlength="20" >
                    </td>
                    <td class=title>보험접수NO</td>
                    <td> 
                      <input type="text" name="our_num" value="<%=a_bean.getOur_num()%>" size="15" class=text maxlength="30" >
                    </td>
                    <td class=title>피해발생</td>
                    <td> 
                      <select name="our_dam_st">
                        <option value=""  <%if(a_bean.getOur_dam_st().equals("")){%> selected<%}%>>없음</option>
                        <option value="1" <%if(a_bean.getOur_dam_st().equals("1")){%>selected<%}%>>대인</option>
                        <option value="2" <%if(a_bean.getOur_dam_st().equals("2")){%>selected<%}%>>대물</option>
                        <option value="3" <%if(a_bean.getOur_dam_st().equals("3")){%>selected<%}%>>대인+대물</option>
                      </select>
                    </td>
                    <td class=title>과실비율</td>
                    <td> 
                      <input type="text" name="our_fault_per" value="<%=a_bean.getOur_fault_per()%>" size="4" class=text maxlength="15" >%
                    </td>			
                </tr>
                <tr> 
                    <td class=title>대인담당자명</td>
                    <td> 
                      <input type="text" name="our_hum_nm" value="<%=a_bean.getHum_nm()%>" size="15" class=text maxlength="10">
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="our_hum_tel" value="<%=a_bean.getHum_tel()%>" size="15" class=text maxlength="15" >
                    </td>		  
                    <td class=title>대물담당자명</td>
                    <td> 
                      <input type="text" name="our_mat_nm" value="<%=a_bean.getMat_nm()%>" size="15" class=text maxlength="10">
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="our_mat_tel" value="<%=a_bean.getMat_tel()%>" size="15" class=text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(a_bean.getAccid_st().equals("1") || a_bean.getAccid_st().equals("2") || a_bean.getAccid_st().equals("3")){//피해,쌍방%>
    <%if(oa_r.length > 0){
		for(int i=0; i<oa_r.length; i++){
    			oa_bean = oa_r[i];%>	
    <tr> 
        <td>&nbsp;&nbsp;<font color=red><%=i+2%>. 상대차량(<%=i+1%>)</font></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
            	    <td class=line2 colspan=2 style='height:1'></td>
            	</tR>
                <tr> 
                    <td class=title rowspan="2" width=8%>운전자</td>
                    <td class=title width=9%>운전자명</td>
                    <td width=14%> 
                      <input type="text" name="ot_driver" value="<%=oa_bean.getOt_driver()%>"  size="15" class=text maxlength="10" >
					  <input type='hidden' name='seq_no' value='<%=oa_bean.getSeq_no()%>'>
                    </td>
                    <td class=title width=9%>생년월일</td>
                    <td width=14%> 
                      <input type="text" name="ot_ssn" value="<%=AddUtil.ChangeSsn(oa_bean.getOt_ssn())%>"  size="15" class=text maxlength="8">
                    </td>
                    <td class=title width=9%>면허번호</td>
                    <td width=14%> 
                      
                      <input type="text" name="ot_lic_no" value="<%=oa_bean.getOt_lic_no()%>" size="15" class=text maxlength="16" >
                    </td>
                    <td class=title width=9%>면허종별</td>
                    <td width=14%> 
                      <input type="text" name="ot_lic_kd" value="<%=oa_bean.getOt_lic_kd()%>" size="15" class=text maxlength="10" >
                    </td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td> 
                      <input type="text" name="ot_car_no" value="<%=oa_bean.getOt_car_no()%>" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>차종</td>
                    <td> 
                      <input type="text" name="ot_car_nm" value="<%=oa_bean.getOt_car_nm()%>" size="15" class=text maxlength="30" >
                    </td>
                    <td class=title>휴대폰</td>
                    <td> 
                      <input type="text" name="ot_m_tel" value="<%=oa_bean.getOt_m_tel()%>" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_tel" value="<%=oa_bean.getOt_tel()%>" size="15" class=text maxlength="15" >
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="3">보험사</td>
                    <td class=title>보험사명</td>
                    <td colspan="5">
					  <input type="text" name="ot_ins" value="<%=oa_bean.getOt_ins()%>" size="20" class='text' maxlength="20" readonly >
					  <a href="javascript:find_gov_search('<%=i%>');" titile='보험사 검색'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <% 	if(!oa_bean.getOt_ins().equals("")){
						  		Hashtable ins_com = ai_db2.getInsCom("", oa_bean.getOt_ins());						  		
					  %>	  		
					  &nbsp;
					  (<%=oa_bean.getOt_ins()%> 연락처:<%=ins_com.get("AGNT_TEL")%>/FAX:<%=ins_com.get("AGNT_FAX")%>/긴급출동:<%=ins_com.get("AGNT_IMGN_TEL")%>/사고접수:<%=ins_com.get("ACC_TEL")%>)
				 	  <%	   		
					  		}	  	
					  %>							  
                    </td>
                    <td class=title>보험접수NO</td>
                    <td> 
                      <input type="text" name="ot_num" value="<%=oa_bean.getOt_num()%>" size="15" class=text maxlength="30" >
                    </td>
                </tr>
                <tr> 					
                    <td class=title>피해발생</td>
                    <td colspan="3"> 
                      <select name="ot_dam_st">
                        <option value=""  <%if(oa_bean.getOt_dam_st().equals("")){%>  selected<%}%>>없음</option>
                        <option value="1" <%if(oa_bean.getOt_dam_st().equals("1")){%> selected<%}%>>대인</option>
                        <option value="2" <%if(oa_bean.getOt_dam_st().equals("2")){%> selected<%}%>>대물</option>
                        <option value="3" <%if(oa_bean.getOt_dam_st().equals("3")){%> selected<%}%>>대인+대물</option>
                      </select>
                    </td>
                    <td class=title>과실비율</td>
                    <td colspan="3"> 
                      <input type="text" name="ot_fault_per" value="<%=oa_bean.getOt_fault_per()%>" size="4" class=text maxlength="15" >%
                    </td>				
                </tr>
                <tr> 
                    <td class=title>대인담당자명</td>
                    <td> 
                      <input type="text" name="ot_hum_nm" value="<%=oa_bean.getHum_nm()%>" size="15" class=text maxlength="10">
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_hum_tel" value="<%=oa_bean.getHum_tel()%>" size="15" class=text maxlength="15" >
                    </td>		  
                    <td class=title>대물담당자명</td>
                    <td> 
                      <input type="text" name="ot_mat_nm" value="<%=oa_bean.getMat_nm()%>" size="15" class=text maxlength="10" >
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_mat_tel" value="<%=oa_bean.getMat_tel()%>" size="15" class=text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%		}
		}%>
	<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr> 
        <td>               
        <%	if( nm_db.getWorkAuthUser("전산팀",user_id)  ||nm_db.getWorkAuthUser("본사관리팀장",user_id) ){%> 
          <a href="javascript:add_display();"><img src="/acar/images/center/button_reg_cgcar.gif" align="absmiddle" border="0">
        <% } else { %>  
	        <%	if(a_bean.getSettle_st().equals("0")){%>
	        <a href="javascript:add_display();"><img src="/acar/images/center/button_reg_cgcar.gif" align="absmiddle" border="0">
	        <% } %>
        <% } %>
        </td>
        <td align="right"><a href="javascript:save('ot', 'i', '')" onMouseOver="window.status=''; return true" onFocus="this.blur()"> 
        </a></td>
    </tr>
	<%	}%>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr id=tr1 style='display:none'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
            	    <td class=line2 colspan=2 style='height:1'></td>
            	</tR>
                <tr> 
                    <td class=title rowspan="2" width=8%>운전자</td>
                    <td class=title width=9%>운전자명</td>
                    <td width=14%> 
                      <input type="text" name="ot_driver" value=""  size="15" class=text maxlength="10" >
					  <input type='hidden' name='seq_no' value='<%=oa_r.length+1%>'>
                    </td>
                    <td class=title width=9%>생년월일</td>
                    <td width=14%> 
                      <input type="text" name="ot_ssn" value=""  size="15" class=text maxlength="8">
                    </td>
                    <td class=title width=9%>면허번호</td>
                    <td width=14%> 
                      
                      <input type="text" name="ot_lic_no" value="" size="15" class=text maxlength="16"  >
                    </td>
                    <td class=title width=9%>면허종별</td>
                    <td width=14%> 
                      <input type="text" name="ot_lic_kd" value="" size="15" class=text maxlength="10" >
                    </td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td> 
                      <input type="text" name="ot_car_no" value="" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>차종</td>
                    <td> 
                      <input type="text" name="ot_car_nm" value="" size="15" class=text maxlength="30" >
                    </td>
                    <td class=title>휴대폰</td>
                    <td> 
                      <input type="text" name="ot_m_tel" value="" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_tel" value="" size="15" class=text maxlength="15" >
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="3">보험사</td>
                    <td class=title>보험사명</td>
                    <td colspan="3"> 
					  <input type="text" name="ot_ins" value="<%//=oa_bean.getOt_ins()%>" size="20" class='text' maxlength="20" readonly >
					  <%if(oa_r.length > 0){%>
					  <a href="javascript:find_gov_search('<%=oa_r.length%>');" titile='보험사 검색'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <%}else{%>
					  <a href="javascript:find_gov_search('');" titile='보험사 검색'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <%}%>
                    </td>
                    <td class=title>보험접수NO</td>
                    <td colspan="3"> 
                      <input type="text" name="ot_num" value="" size="15" class=text maxlength="30" >
                    </td>
                </tr>
                <tr> 					
                    <td class=title>피해발생</td>
                    <td colspan="3"> 
                      <select name="ot_dam_st">
                        <option value="">없음</option>
                        <option value="1">대인</option>
                        <option value="2">대물</option>
                        <option value="3">대인+대물</option>
                      </select>
                    </td>
                    <td class=title>과실비율</td>
                    <td colspan="3"> 
                      <input type="text" name="ot_fault_per" value="" size="4" class=text maxlength="15" >%
                    </td>					
                </tr>
                <tr> 
                    <td class=title>대인담당자명</td>
                    <td> 
                      <input type="text" name="ot_hum_nm" value="" size="15" class=text maxlength="10">
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_hum_tel" value="" size="15" class=text maxlength="15" >
                    </td>
                    <td class=title>대물담당자명</td>
                    <td> 
                      <input type="text" name="ot_mat_nm" value="" size="15" class=text maxlength="10" >
                    </td>
                    <td class=title>연락처</td>
                    <td> 
                      <input type="text" name="ot_mat_tel" value="" size="15" class=text maxlength="15" >
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr2 style='display:none'> 
        <td><font color="#0099FF"> </font></td>
        <td align="right"> 
        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:save('ot', 'i', '')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        <%	}%>
        </td>
    </tr>	
    <%}%>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
