<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.doc_settle.*, acar.user_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OneAccidBean" scope="page"/>
<jsp:useBean id="oa_bean2" class="acar.accid.OneAccidBean" scope="page"/>
<jsp:useBean id="ot_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
	String mode = request.getParameter("mode")==null?"13":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	//정비/점검(면책금)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	ServiceBean s_bean = as_db.getService(c_id, accid_id);
	
	//보험청구내역(휴차/대차료)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id);	
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
//	if(!car_st.equals(""))	car_st = car_st.substring(4,5);	
	if(!car_st.equals("")){
		if(car_st.indexOf("허") != -1){
			car_st = car_st.substring(4,5);	
		}
	}
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("45", c_id+""+accid_id);
	String doc_no = doc.getDoc_no();
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
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
	function save(){	
		var fm = document.form1;	
		if(fm.settle_st.value == '1'){ 
			if(fm.settle_dt.value == ''){ alert('종료일자를 입력하십시오.'); return; }
			if(fm.settle_cont.value == ''){ alert('기타란에 사고결과를 정확히 입력하십시오.'); return; }
			if(fm.settle_id.value == ''){ alert('처리결과 종료 처리담당자를 입력하십시오.'); return; }
		}
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.target = "i_no";
		fm.submit();
	}		
	
	//사고처리결고문서 이동
	function move_doc(){
		var fm = document.form1;
		fm.go_url.value = '/acar/accid_mng/accid_u_frame.jsp';
		fm.target = 'd_content';
		fm.action = '/fms2/accid_mng/accid_result_c.jsp';
		fm.submit();		
	}	
		//사고처리결고문서 이동
	function update_doc(accid_id, c_id){
		var fm = document.form1;	
		window.open("./accid_pre_doc.jsp?c_id="+c_id + "&accid_id=" +accid_id, "pre", "left=400, top=220, width=530, height=250, resizable=yes, scrollbars=yes, status=yes");
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
    <input type='hidden' name='h_accid_dt' value=''>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
	<input type='hidden' name='doc_no' value='<%=doc_no%>'>  		
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>처리 진행상황</span></td>
        <td align="right"> 
        <% if((a_bean.getSettle_st().equals("0") && doc_no.equals("")) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ){ %>
        <%	if(auth_rw.equals("1") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
        <%	}%>
        <% } %>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>사고일시</td>
                    <td  height="76">&nbsp;<%=AddUtil.ChangeDate3(a_bean.getAccid_dt())%> </td>
                    <td colspan="2">&nbsp;
                   <% if(a_bean.getPre_doc().equals("P")) {%> <font  color=red>  * 과실확정전 사전결재 </font> &nbsp;&nbsp;<a href="javascript:update_doc('<%=accid_id%>', '<%=c_id%>')">종결처리</a> <% } %>
                  </td>
                  <td class=title width=9%>처리담당</td>
                    <td width=33%> 
                      &nbsp;<select name='settle_id'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>		
                <tr> 
                    <td class=title>최종진행상태</td>
                    <td width=22%> 
                      &nbsp;<select name='settle_st'>
                        <option value="0" <%if(a_bean.getSettle_st().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td class=title width=9%>최종종결일자</td>
                    <td width=18%> 
                      &nbsp;<input type="text" name="settle_dt" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=9%><font color=red>폐차여부</font></td>
                    <td width=33%> 
                     &nbsp;<select name='asset_st'>
                        <option value="" <%if(a_bean.getAsset_st().equals("")){%>selected<%}%>>선택</option>
                        <option value="Y" <%if(a_bean.getAsset_st().equals("Y")){%>selected<%}%>>폐차</option>
                      </select>
                     
                    </td>
                </tr>
		
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="5" height="76"> 
                     &nbsp;<textarea name="settle_cont" cols="120" rows="3"><%=a_bean.getSettle_cont()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>구분</td>
                    <td class=title width=49%>내용</td>
                    <td class=title width=14%>진행상태</td>
                    <td class=title width=14%>종결일자</td>
                    <td class=title width=14%>처리담당</td>
                </tr>
    		  <%//대인
    		  	if(a_bean.getDam_type1().equals("Y")){
    		 		//자기신체사고-대인
    				OneAccidBean oa_r [] = as_db.getOneAccid(c_id, accid_id, "2");%>
                <tr> 
                    <td align="center">대인</td>
                    <td>(<%=oa_r.length%>건) 보상금 : <%=AddUtil.parseDecimal(a_bean.getHum_amt())%>원 (보상완료일 <%=AddUtil.ChangeDate2(a_bean.getHum_end_dt())%>)</td>
                    <td align="center">
                      <select name='settle_st1'>
                        <option value="0" <%if(a_bean.getSettle_st1().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st1().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="settle_dt1" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt1())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <select name='settle_id1'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id1().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
      		  <%}%>
    		  <%//대물
    	  		if(a_bean.getDam_type2().equals("Y")){
    				//상대차량 인적사항
    				OtAccidBean oa_r2 [] = as_db.getOtAccid(c_id, accid_id);
    				int serv_amt = 0;
    				for(int i=0; i<oa_r2.length; i++){
    		    		ot_bean = oa_r2[i];
    					serv_amt = serv_amt + ot_bean.getServ_amt();
    				}%>
                <tr> 
                    <td align="center">대물</td>
                    <td>(<%=oa_r2.length%>건) 정비금액 : <%=AddUtil.parseDecimal(serv_amt)%>원, 보상금 : <%=AddUtil.parseDecimal(a_bean.getMat_amt())%>원 (보상완료일 <%=AddUtil.ChangeDate2(a_bean.getMat_end_dt())%>)</td>
                    <td align="center"> 
                      <select name='settle_st2'>
                        <option value="0" <%if(a_bean.getSettle_st2().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st2().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="settle_dt2" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt2())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <select name='settle_id2'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id2().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
    		  <%}%>
       		  <%//자손
    	  		if(a_bean.getDam_type3().equals("Y")){
    				//자기신체사고
    				OneAccidBean oa_r [] = as_db.getOneAccid(c_id, accid_id, "1");%>
                <tr> 
                    <td align="center">자손</td>
                    <td>(<%=oa_r.length%>건) 보상금 : <%=AddUtil.parseDecimal(a_bean.getOne_amt())%>원 (보상완료일 <%=AddUtil.ChangeDate2(a_bean.getOne_end_dt())%>)</td>
                    <td align="center"> 
                      <select name='settle_st3'>
                        <option value="0" <%if(a_bean.getSettle_st3().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st3().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="settle_dt3" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt3())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <select name='settle_id3'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id3().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
    		  <%}%>
    		  <%//자차
    	  		if(a_bean.getDam_type4().equals("Y")){%>
                <tr> 
                    <td align="center">자차</td>
                    <td>(<%=s_r.length%>건) 정비금액 : <%=AddUtil.parseDecimal(s_bean.getTot_amt())%>원 (정비일 <%=s_bean.getServ_dt()%>), 면책금 : <%=AddUtil.parseDecimal(s_bean.getCust_amt())%>원 (입금일 <%=AddUtil.ChangeDate2(s_bean.getCust_pay_dt())%>)</td>
                    <td align="center"> 
                      <select name='settle_st4'>
                        <option value="0" <%if(a_bean.getSettle_st4().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st4().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="settle_dt4" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt4())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <select name='settle_id4'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id4().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
    		  <%}%>
    		  <%//휴/대차료
    	  		 if(ma_bean.getIns_req_st().equals("1") || ma_bean.getIns_req_st().equals("2")){%>
                <tr> 
                    <td align="center"><%if(car_st.equals("허")||ma_bean.getIns_req_gu().equals("1")){%>휴차료<%}else{%>대차료<%}%></td>
                    <td>(<%=ma_bean.getIns_use_day()%>일) 청구금액 : <%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>원, 입금금액 : <%=AddUtil.parseDecimal(ma_bean.getIns_pay_amt())%>원 (입금일 <%=AddUtil.ChangeDate2(ma_bean.getIns_pay_dt())%>)</td>
                    <td align="center"> 
                      <select name='settle_st5'>
                        <option value="0" <%if(a_bean.getSettle_st5().equals("0")){%>selected<%}%>>진행처리</option>
                        <option value="1" <%if(a_bean.getSettle_st5().equals("1")){%>selected<%}%>>종결처리</option>
                      </select>
                    </td>
                    <td align="center"> 
                      <input type="text" name="settle_dt5" value="<%=AddUtil.ChangeDate2(a_bean.getSettle_dt5())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                      <select name='settle_id5'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getSettle_id5().equals(user.get("USER_ID"))||a_bean.getReg_id().equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
    		  <%}%>
            </table>
        </td>
    </tr>	
	<%if(!doc_no.equals("")){%>
    <tr>
		<td colspan=2>&nbsp;</td>
	</tr> 			
	<tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=20%>지점명</td>					
                    <td class=title width=20%>기안자</td>
                    <td class=title width=20%>고객지원팀장</td>
                    <td class=title width=30%>-</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%></font></td>
                    <td>&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>	
	<%}%>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
