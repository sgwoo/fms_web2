<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="coev_bean" class="acar.car_office.CarOffEmpVisBean" scope="page"/>
<jsp:useBean id="coc_bean" class="acar.car_office.CarOffCngBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "04");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");			

	coe_bean = cod.getCarOffEmpBean(emp_id);
		
	CarCompBean cc_r [] = cod.getCarCompAll();	//자동차회사
	CodeBean cd_r [] = c_db.getCodeAll_bank("0003");	//은행명을 가져온다.
	CommiBean cm_r [] = cod.getCommiAll(emp_id);
	//메모관리
	CarOffEmpVisBean coev_r [] = cod.getCarOffEmpVisAll(emp_id);
	Vector commis = cod.getCommiList(emp_id);
	String firm_nm = "";
	if(commis.size() > 0){
		Hashtable ht = (Hashtable)commis.elementAt(0);
		firm_nm = (String)ht.get("FIRM_NM");
	}
	//근무처관리
	CarOffCngBean[] cngs = cod.getCarOffCng(emp_id);
	//담당자변경이력
	CarOffEdhBean[] cohList  = cod.getCar_off_edh(emp_id); 
	coh_bean = cohList[cohList.length-1];

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function go_page(arg){
	if(arg=="i"){
		document.location.href = "./car_office_p_i.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";
	}else if(arg=="u"){
		document.location.href = "./car_office_p_u.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&emp_id=<%= emp_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";
	}else if(arg=="b"){
		document.location.href = "./car_office_p_frame.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&cng_rsn=<%=cng_rsn%>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>";	
	}else{
		alert("잘못 선택되었습니다.");
	}
}
function go_list(){
	var fm = document.CarOffEmpForm;
	fm.action  = "./car_office_p_frame.jsp";
	fm.target = "d_content";
	fm.submit();
}
function OpenMemo(emp_id)
{
	var theForm = document.CarOffEmpUpdateForm;
	var auth_rw = theForm.auth_rw.value;
	var SUBWIN="./office_memo_i.jsp?emp_id="+emp_id + "&auth_rw=" +auth_rw;	
	window.open(SUBWIN, "Memo", "left=100, top=100, width=570, height=320, scrollbars=no");
}
function VisReg()
{
	var theForm = document.CarOffEmpForm;
	if(!confirm('등록하시겠습니까?')){		return;	}
	theForm.cmd.value = "i";
	theForm.target = "i_no"
	theForm.action = "office_memo_null_ui.jsp";
	theForm.submit();
}
function open_commi(emp_id){
	var SUBWIN="./cont_list.jsp?emp_id="+emp_id;	
	window.open(SUBWIN, "commi_list", "left=100, top=100, width=840, height=320, scrollbars=yes");
}
function view_memo(arg){
	if(arg=="all"){
		memoall.style.display = '';
		memolast.style.display = "none";
	}else{
		memoall.style.display = 'none';
		memolast.style.display = "";
	}
}
function view_car_off_cng(arg){
	if(arg=="all"){
		coall.style.display = '';
		coall2.style.display = '';
	}else if(arg="last"){
		coall.style.display = 'none';
		coall2.style.display = 'none';
		colast.style.display = "";
	}
}
function update_list(){
	var SUBWIN="./update_list.jsp?emp_id=<%= emp_id %>";	
	window.open(SUBWIN, "update_list", "left=100, top=100, width=440, height=320, scrollbars=yes");	
}
function sms_list(arg){
	var SUBWIN="/acar/sms_gate/sms_result_sc2.jsp?dest_gubun=1&rslt_dt=0&dest_nm="+arg;
	window.open(SUBWIN, "sms_list", "left=100, top=100, width=850, height=600, scrollbars=yes");	
}
function damdang_list(){
	var SUBWIN="./damdang_list.jsp?emp_id=<%= emp_id %>";	
	window.open(SUBWIN, "update_list", "left=100, top=100, width=440, height=320, scrollbars=yes");	
}

-->
</script>
</head>

<body>
<form action="./car_off_null_p_ui.jsp" name="CarOffEmpForm" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="emp_id" value="<%=emp_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><font color="navy">영업지원 -> </font><a href="/acar/car_office/car_office_p_frame.jsp"><font color="navy">자동차영업사원관리</font></a> 
        -> <font color="red">영업사원조회</font></td>
    </tr>
    <tr> 
      <td><div align="right">
	  	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href="javascript:go_page('i')" onMouseOver="window.status=''; return true"> 
          <img src="/images/new_reg.gif" width="67" height="18" aligh="absmiddle" border="0"></a> 
          <a href="javascript:go_page('u')" onMouseOver="window.status=''; return true"> 
          <img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	  	  <%}%>	  
          <a href="javascript:go_page('b')" onMouseOver="window.status=''; return true"> 
          <img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></div></td>
    </tr>
    <tr> 
      <td><table width="800" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="2">1. 담당자관리</td>
          </tr>
          <tr> 
            <td width="20">&nbsp;</td>
            <td width="780" class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td width="150" class="title">담당자</td>
                  <td width="240">&nbsp; <%= c_db.getNameById(coh_bean.getDamdang_id(),"USER") %></td>
                  <td width="150" class="title">지정(변경)일자</td>
                  <td width="240">&nbsp; <%= AddUtil.ChangeDate2(coh_bean.getCng_dt()) %></td>
                </tr>
                <tr> 
                  <td class="title">지정사유</td>
                  <td>&nbsp; <% if(coh_bean.getCng_rsn().equals("1"))	 out.print("1.최근계약");
				  			else if(coh_bean.getCng_rsn().equals("2")) out.print("2.대면상담");
				  			else if(coh_bean.getCng_rsn().equals("3")) out.print("3.전화상담");
				  			else if(coh_bean.getCng_rsn().equals("4")) out.print("4.전산배정");														
				  			else if(coh_bean.getCng_rsn().equals("5")) out.print("5.기타"); %>
                  </td>
                  <td class="title">변경이력</td>
                  <td>&nbsp; <% if(cohList.length>1){ %><a href="javascript:damdang_list()"  onMouseOver="window.status=''; return true">리스트보기</a>
				  			<% }else{ %>없음
							<% } %></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">2. 고객기초사항관리</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150" class="title">성명</td>
                        <td width="240">&nbsp; <%= coe_bean.getEmp_nm() %></td>
                        <td width="50" rowspan="2" class="title">연락처</td>
                        <td width="100" class="title">전화</td>
                        <td width="240">&nbsp; <%= coe_bean.getEmp_h_tel() %></td>
                      </tr>
                      <tr> 
                        <td class="title">소득구분</td>
                        <td>&nbsp; <input type="radio" name="cust_st" value="2"  <% if(coe_bean.getCust_st().equals("2")||coe_bean.getCust_st().equals("")) out.println("checked"); %>>
                          사업소득&nbsp; <input type="radio" name="cust_st" value="3"  <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>
                          기타사업소득</td>
                        <td class="title">핸드폰</td>
                        <td>&nbsp; <%= coe_bean.getEmp_m_tel() %></td>
                      </tr>
                      <tr> 
                        <td class="title">주민등록번호</td>
                        <td>&nbsp; <%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %> 
                        </td>
                        <td colspan="2" class="title">성별</td>
                        <td>&nbsp; <input type="radio" name="emp_sex" value="2"  <% if(coe_bean.getEmp_sex().equals("1")) out.println("checked"); %>>
                          남성 
                          <input type="radio" name="emp_sex" value="3"  <% if(coe_bean.getEmp_sex().equals("2")) out.println("checked"); %>>
                          여성 </td>
                      </tr>
                      <tr> 
                        <td class="title">현주소</td>
                        <td colspan="4">&nbsp; <%= coe_bean.getEmp_post() %> &nbsp; 
                          <%= coe_bean.getEmp_addr() %></td>
                      </tr>
                      <tr> 
                        <td class="title">메일주소</td>
                        <td colspan="4">&nbsp; <%= coe_bean.getEmp_email() %></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">3. 근무처관리 
              <% if(cngs.length>0){ %>
              <a href="javascript:view_car_off_cng('all')">전체보기</a>&nbsp; <a href="javascript:view_car_off_cng('last')">취소</a> 
              <% } %>
              <% if(coev_r.length>0 && cngs.length>0){ %>
              <a href="javascript:update_list()"><span title="변경등록 이력을 볼 수 있습니다.">근무처,메모 
              변경이력</span></a> 
              <% } %>
            </td>
          </tr>
          <tr id="coall" style="display:none;"> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <% for(int j=0; j<cngs.length; j++){
				  		coc_bean = cngs[j];
						co_bean = cod.getCarOffBean(coc_bean.getCar_off_id()); %>
                <tr> 
                  <td>3-<%= j+1 %>. 이전근무처</td>
                </tr>
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td colspan="2" class="title">제작사명</td>
                        <td>&nbsp; 
                          <%for(int i=0; i<cc_r.length; i++){
							cc_bean = cc_r[i];
							if(cc_bean.getCode().equals(co_bean.getCar_comp_id())) out.print(cc_bean.getNm());
						} %>
                        </td>
                        <td colspan="2" class="title">직위</td>
                        <td width="240">&nbsp; <%= coc_bean.getEmp_pos() %></td>
                      </tr>
                      <tr> 
                        <td width="50" rowspan="2" class="title">근무처</td>
                        <td width="100" class="title">상호(부서명)</td>
                        <td width="240">&nbsp; <%= co_bean.getCar_off_nm() %></td>
                        <td width="50" rowspan="2" class="title">연락처</td>
                        <td width="100" class="title">전화</td>
                        <td>&nbsp; <%= co_bean.getCar_off_tel() %></td>
                      </tr>
                      <tr> 
                        <td class="title">구분</td>
                        <td>&nbsp; <input type="radio" name="car_off_st_old<%= j %>" value="1" <% if(co_bean.getCar_off_st().equals("1")) out.println("checked"); %>>
                          지점 
                          <input type="radio" name="car_off_st_old<%= j %>" value="2" <% if(co_bean.getCar_off_st().equals("2")) out.println("checked"); %>>
                          대리점</td>
                        <td class="title">FAX</td>
                        <td>&nbsp; <%= co_bean.getCar_off_fax() %></td>
                      </tr>
                      <tr> 
                        <td colspan="2" class="title">주소</td>
                        <td colspan="4">&nbsp; <%= co_bean.getCar_off_post() %>&nbsp;<%= co_bean.getCar_off_addr() %></td>
                      </tr>
                    </table></td>
                </tr>
                <% } %>
              </table></td>
          </tr>
          <tr id="coall2" style="display:none;"> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>3-<%= cngs.length+1 %>. 현재근무처</td>
                </tr>
              </table></td>
          </tr>
          <tr id="colast" style="display:''"> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td colspan="2" class="title">제작사명</td>
                        <td>&nbsp; 
                          <%for(int i=0; i<cc_r.length; i++){
							cc_bean = cc_r[i];
							if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print(cc_bean.getNm());
						} %>
                        </td>
                        <td colspan="2" class="title">직위</td>
                        <td width="240">&nbsp; <%= coe_bean.getEmp_pos() %></td>
                      </tr>
                      <tr> 
                        <td width="50" rowspan="2" class="title">근무처</td>
                        <td width="100" class="title">상호(부서명)</td>
                        <td width="240">&nbsp; <%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %></td>
                        <td width="50" rowspan="2" class="title">연락처</td>
                        <td width="100" class="title">전화</td>
                        <td>&nbsp; <%= coe_bean.getCar_off_tel() %></td>
                      </tr>
                      <tr> 
                        <td class="title">구분</td>
                        <td>&nbsp; <input type="radio" name="car_off_st" value="1" <% if(coe_bean.getCar_off_st().equals("1")) out.println("checked"); %>>
                          지점 
                          <input type="radio" name="car_off_st" value="2" <% if(coe_bean.getCar_off_st().equals("2")) out.println("checked"); %>>
                          대리점</td>
                        <td class="title">FAX</td>
                        <td>&nbsp; <%= coe_bean.getCar_off_fax() %></td>
                      </tr>
                      <tr> 
                        <td colspan="2" class="title">주소</td>
                        <td colspan="4">&nbsp; <%= coe_bean.getCar_off_post() %>&nbsp;<%= coe_bean.getCar_off_addr() %></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">4. 예금계좌관리</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150" class="title">은행명</td>
                        <td width="240">&nbsp; <select name="emp_bank" disabled style="width:135">
                            <option value="">==선택==</option>
                            <%for(int i=0; i<cd_r.length; i++){
							cd_bean = cd_r[i];%>
                            <option value="<%= cd_bean.getNm() %>" <% if(cd_bean.getNm().equals(coe_bean.getEmp_bank())) out.print("selected"); %>><%= cd_bean.getNm() %></option>
                            <%}%>
                          </select></td>
                        <td width="150" class="title">예금주명</td>
                        <td width="240">&nbsp; <%= coe_bean.getEmp_acc_nm() %></td>
                      </tr>
                      <tr> 
                        <td class="title">계좌번호</td>
                        <td colspan="3">&nbsp; <%= coe_bean.getEmp_acc_no() %></td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">5. 고객정보(메모) 
              <% if(coev_r.length>1){ %>
              <a href="javascript:view_memo('all')">전체보기</a>&nbsp; <a href="javascript:view_memo('last')">취소</a> 
              <% } %>
            </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr id="memolast" style="display:<% if(coev_r.length>0){ %>''<% }else{ %>none<% } %>;"> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <%if(coev_r.length>0){
					    	coev_bean = coev_r[coev_r.length-1]; %>
                      <tr> 
                        <td width="150" class="title">메모<%= coev_r.length %></td>
                        <td width="630">&nbsp; <textarea name="cont" rows="2" cols="90" readonly><%= coev_bean.getVis_cont() %></textarea></td>
                      </tr>
                      <% } %>
                    </table></td>
                </tr>
                <tr id="memoall" style="display:none;"> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <%for(int i=0; i<coev_r.length; i++){
					    	coev_bean = coev_r[i]; %>
                      <tr> 
                        <td width="150" class="title">메모<%= i+1 %></td>
                        <td width="630">&nbsp; <textarea name="cont" rows="2" cols="90" readonly><%= coev_bean.getVis_cont() %></textarea></td>
                      </tr>
                      <% } %>
                    </table></td>
                </tr>
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150"  class="title"><a href="javascript:VisReg()" onMouseOver="window.status=''; return true"><span title="내용을 입력하시고 클릭하면, 추가됩니다">추가</span></a></td>
                        <td width="630">&nbsp; <textarea name="vis_cont" rows="2" cols="90"></textarea></td>
                        <input type="hidden" name="sub" value="메모<%= coev_r.length+1 %>">
                        <input type="hidden" name="vis_nm" value="<%= user_id %>">
                        <input type="hidden" name="vis_dt" value="<%= AddUtil.dateFormat("yyyyMMdd") %>">
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">6. 계약정보/지급수수료관리</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150" class="title"> 
                          <% if(commis.size()>0){ %>
                          <a href="javascript:open_commi('<%= emp_id %>')" onMouseOver="window.status=''; return true"><span title="클릭하시면 내용을 볼 수 있습니다.">거래내역</span></a> 
                          <% }else{ %>
                          거래내역 
                          <% } %>
                        </td>
                        <td width="630">&nbsp; <%= firm_nm %> 
                          <% if(commis.size()>0) out.print("외 "+commis.size()+"건"); %>
                        </td>
                      </tr>
                    </table></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td colspan="2">7. SMS관리</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                      <tr> 
                        <td width="150" class="title">수신여부</td>
                        <td width="240">&nbsp; <input type="radio" name="use_yn" value="Y" disabled <% if(coe_bean.getUse_yn().equals("Y")) out.print("checked"); %>>
                          수신&nbsp;&nbsp; <input type="radio" name="use_yn" value="N" disabled <% if(coe_bean.getUse_yn().equals("N")) out.print("checked"); %>>
                          거부</td>
                        <td width="150" class="title">문자발송</td>
                        <td width="240">&nbsp;<a href="javascript:sms_list('<%= coe_bean.getEmp_nm() %>');">리스트보기</a></td>
                      </tr>
                      <% if(coe_bean.getUse_yn().equals("N")){ %>
                      <tr> 
                        <td class="title">수신거부사유</td>
                        <td colspan="3">&nbsp; <%= coe_bean.getSms_denial_rsn() %></td>
                      </tr>
                      <% } %>
                    </table></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
