<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//변수
	String u_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_id1");//담당부서장
	String u_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_id2");	//담당자
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//첨부서류1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//첨부서류2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//첨부서류3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//첨부서류4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//첨부서류5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//첨부서류6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//첨부서류7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//첨부서류8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//첨부서류9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//첨부서류10
	String d_var11 = e_db.getEstiSikVarCase("1", "", "myaccid_app11");//첨부서류11
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "HEAD2", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	//수신처검색하기
	function find_gov_search(){
		var fm = document.form1;	
		window.open("find_gov_search.jsp", "SEARCH_FINE_GOV", "left=100, top=100, width=750, height=550, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//공문미등록보험사조회
	function find_inscom_search(){
		var fm = document.form1;	
		window.open("find_inscom_search.jsp", "SEARCH_FINE_INSCOM", "left=100, top=100, width=850, height=750, resizable=yes, scrollbars=yes, status=yes");
	}	
	//공물발행의뢰 조회	
	function find_docreq_search(){
		var fm = document.form1;	
		window.open("find_docreq_search.jsp", "SEARCH_FINE_DOCREQ", "left=100, top=100, width=850, height=750, resizable=yes, scrollbars=yes, status=yes");
	}
	
	
	//휴/대차료 검색하기
	function find_accid_search(){
		var fm = document.form1;
		if(fm.gov_nm.value == '') { alert('보험사를 확인하십시오.'); return; }
		window.open("find_myaccid_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gov_id="+fm.gov_id.value+"&t_wd="+fm.ins_com.value, "SEARCH_FINE", "left=50, top=50, width=850, height=750, resizable=yes, scrollbars=yes, status=yes");
	}	
	
			
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}	
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=yes,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "/tax/pop_search/s_cont.jsp";
		fm.target = "search_open";
		fm.submit();		
	}
				
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="<%=go_url%>">      
  <input type="hidden" name="ins_com" value="">  
  <input type="hidden" name="app_docs" value="">  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > <span class=style5>대차료청구공문등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class="line">   
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="12%">문서번호</td>
            <td width=88%>&nbsp;  
              <input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getSettleDocIdNext("손해")%>">
            </td>
          </tr>
          <tr> 
            <td class='title'>시행일자</td>
            <td>&nbsp; 
              <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
             <td class='title' rowspan="2" >수신</td>
             <td>&nbsp;  
                  <input type="text" name="gov_nm" size="50" class="text" readonly style='IME-MODE: active'>
        		  <input type='hidden' name="gov_id" value=''>
                  <a href="javascript:find_gov_search();" titile='보험사 검색'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
				  <!--&nbsp;&nbsp;|&nbsp;&nbsp;
				  <a href="javascript:find_inscom_search();" titile='공문미등록 대차료 조회'>[공문미등록 대차료 조회]</a>
				  -->
				  &nbsp;&nbsp;|&nbsp;&nbsp;
				  <a href="javascript:find_docreq_search();" titile='공문 발행 의뢰 요청건 조회'>[공문 발행 의뢰 요청건]</a>
        	</td>
          </tr>  
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>		  
          <tr>
            <td>&nbsp;&nbsp;<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7'>
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65">
              (주소)
                         
              </td>
          </tr>
		  <tr> 
                    <td class='title'>참조</td>
                    <td>&nbsp;
					  <input type="text" name="mng_dept" size="50" class="text"> 
                      (담당자명 : 
                      <input name="mng_nm" type="text" class="text" id="mng_nm" size="15">
                      / 담당자직급 : 
                      <input name="mng_pos" type="text" class="text" id="mng_pos" size="15">
                      )</td>
                </tr>
          <tr> 
            <td class='title'>제목</td>
            <td>&nbsp;&nbsp;대차료 청구
			   </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당사</span></td>
    </tr>

    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=12% class='title'>담당부서장</td>
                    <td width=38%>&nbsp;<select name='h_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(u_var1.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                    <td class='title' width=12%>담당자</td>
                    <td width=38%>&nbsp;<select name='b_mng_id'>
                    <option value="">없음</option>
                    <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                    <option value='<%=user.get("USER_ID")%>' <%if(u_var2.equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                    <%		}
        					}		%>
                    </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><a href="javascript:find_accid_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>		    
  </table>
</form>
</body>
</html>
