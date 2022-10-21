<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("auth_rw")==null?"S1":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	
		
		
	
	//시도
	Vector sidoList = c_db.getZip_sido();
	int sido_size = sidoList.size();

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
<!--
//분류구분선택시 다음단계 보여주기
function show_next(arg){
	var fm = document.form1;
	//var rlt = fm.result.value;
	
	if(arg=='1'){
		if(fm.gubun.value=='1'){	//지역일경우,자동차회사는 전체로한다. 그리고 광역시도 선택보여준다.
			tr_cc_id.style.display = "";
			//fm.cc_id.disabled = true;
			tr_sido.style.display = "";
			//fm.result.value =  rlt+", "+"";
			fm.sido.focus();
		}else if(fm.gubun.value=='2'){	//자동차회사일경우, 
			tr_cc_id.style.display = "";
			fm.cc_id.focus();
		}		
		//fm.gubun.disabled=true;	
	}else if(arg=='2'){
		tr_sido.style.display = "";
		fm.sido.focus();
	}else if(arg=='3'){
		tr_sido.style.display = "none";
		tr_sido_result.style.display = "";
		//복수값 결과 나타내기
		for(i=0; i<fm.sido.length; i++){
			if(fm.sido[i].selected == true){
				fm.sido_result.value += fm.sido[i].text+" ";
			}
		}		
		getGugunAll();
		tr_gugun.style.display = "";
		fm.gugun.focus();
	}else if(arg=='4'){
		tr_gugun.style.display = "none";
		tr_gugun_result.style.display = "";
		//복수값 결과 나타내기
		for(i=0; i<fm.gugun.length; i++){
			if(fm.gugun[i].selected == true){
				fm.gugun_result.value += fm.gugun[i].text+" ";
			}
		}		
		tr_send_gubun.style.display = "";
		fm.send_gubun.focus();
	}else if(arg=='5'){
		tr_cng_rsn.style.display = "";
		fm.cng_rsn.focus();
	}else if(arg=='6'){
		tr_commi_yn.style.display = "";
		fm.commi_yn.focus();
	}else if(arg=='7'){
		tr_check.style.display = "";
	}else if(arg=='8'){
		tr_search.style.display = "";
	}
}

//지역구분에 따른 구,군 검색
function getGugunAll(){
	fm = document.form1;
	//기존데이터 삭제
	var gugun_len = fm.gugun.length;
	for(var i = 0 ; i < gugun_len ; i++){
		fm.gugun.options[gugun_len-(i+1)] = null;
	}
	
	fm.action = "./getGugunAll.jsp";
	fm.target = "i_no";
	fm.submit();
}
function add_gugun(idx, val, str){
	document.form1.gugun[idx] = new Option(str, val);
}

//초기화
function init(){
	opener.smsList.location.href = "./sms_list.jsp";
	location.href = "./target_search.jsp";
}

//검색명단 부모윈도우에서 보여주기
function SearchCarOffP(){
	fm = document.form1;
	opener.smsList.smsList_t.location.href = "./sms_list_t.jsp";
	fm.target = "smsList_in";
	fm.action = "./sms_list_in.jsp";
	fm.submit();
}
//중복건 조회
function check_double(){
	window.open("about:blank", "check_double", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	fm.target = "check_double";
	fm.action = "./sms_list_double.jsp";
	fm.submit();
}
//번호오류체크
function check_num(){
	window.open("about:blank", "check_num", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	fm.target = "check_num";
	fm.action = "./sms_list_check_num.jsp";
	fm.submit();

}

-->
</script>
</head>

<body>
<form method="post" name="form1">
<input name="user_id" type="hidden" value="<%= user_id %>">
<input type="hidden" name="gubun1" value="<%= gubun1 %>">
<input type="hidden" name="gubun2" value="<%= gubun2 %>">
  <table width="320" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align="right"><a href="javascript:init()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_init.gif" border="0" align="absbottom"></a> 
        <a href="javascript:this.close();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_close.gif" border="0" align="absbottom"></a></td>
    </tr>
    <tr> 
      <td class="line"><table width="320" border="0" cellspacing="1" cellpadding="0">
	  <tr><td class=line2></td></tr>
          <tr> 
            <td width="110" class="title">발송대상</td>
            <td colspan="2">&nbsp;영업사원</td>
          </tr>
          <tr> 
            <td class="title">발송방식</td>
            <td colspan="2">&nbsp;조직</td>
          </tr>
          <tr> 
            <td colspan="3"><font color="#666666">※검색버튼이 나타날 때까지 선택해 주시기 바랍니다.</font></td>
          </tr>
          <tr> 
            <td class="title">담당자</td>
            <td colspan="2"><select name='s_bus'>
                <option value="">=전체=</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
              </select></td>
          </tr>
          <tr> 
            <td class="title">분류구분 </td>
            <td colspan="2"><select name='gubun' onChange="javascript:show_next('1');">
                <option value="">선택</option>
                <option value="1">지역</option>
                <option value="2">자동차회사</option>
              </select></td>
          </tr>
          <tr id="tr_cc_id" style="display:none;"> 
            <td class="title">자동차회사</td>
            <td colspan="2"><select name="cc_id" onChange="javascript:show_next('2');">
                <option value="">전체 
                <%
			for(int i=0; i<cc_r.length; i++){
				cc_bean = cc_r[i];
		%>
                <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                <%	}%>
              </select></td>
          </tr>
          <tr id="tr_sido_result" style="display:none;"> 
            <td class="title">지역(광역시,도)</td>
            <td colspan="2"><input type="text" class="whitetext" name="sido_result" size="28"></td>
          </tr>
          <tr id="tr_sido" style="display:none;"> 
            <td class="title">지역(광역시,도)<br> <br>
              ※ 복수선택방법:<br>
              Ctrl 키 + 마우스왼쪽버튼</td>
            <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">

                <tr> 
                  <td width="72%"><select name="sido" multiple size="8">
                      <option value="">--전체--</option>
                      <option value="1">서울</option>
                      <option value="2">강원</option>
                      <option value="3">대전,충남,충북</option>
                      <option value="4">인천,경기</option>
                      <option value="5">광주,전남,전북</option>
                      <option value="6">부산,울산,경남,제주</option>
                      <option value="7">대구,경북</option>
                    </select> </td>
                  <td width="28%"><a href="javascript:show_next('3');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr id="tr_gugun_result" style="display:none;"> 
            <td class="title">지역(기초구, 군)</td>
            <td colspan="2"><input type="text" class="whitetext" name="gugun_result" size="28"></td>
          </tr>
          <tr id="tr_gugun" style="display:none;"> 
            <td class="title">지역(기초구, 군)<br> <br>
              ※ 복수선택방법:<br>
              Ctrl 키 + 마우스왼쪽버튼</td>
            <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="72%"><select name="gugun" multiple size="10">
                      <option value="전체">--전체--</option>
                    </select> </td>
                  <td width="28%"><a href="javascript:show_next('4');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr id="tr_send_gubun" style="display:none;"> 
            <td class="title">발송구분</td>
            <td width="148"><select name='send_gubun' multiple size="9">
                <option value="">전체</option>
                <% for(int i=0; i< umd.getMax_gubun(); i++){ %>
                <option value="<%= i+1 %>"><%= i+1 %></option>
                <% } %>
              </select></td>
            <td width="59"><a href="javascript:show_next('5');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
          </tr>
          <tr id="tr_cng_rsn" style="display:none;">
            <td class="title">지정사유</td>
            <td><select name="cng_rsn">
                <option value="">==전체==</option>
                <option value="1">1.최근계약</option>
                <option value="2">2.대면상담</option>
                <option value="3">3.최초등록</option>
                <option value="4">4.SMS배정</option>
                <option value="5">5.기타</option>
              </select></td>
            <td><a href="javascript:show_next('6');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
          </tr>
          <tr id="tr_commi_yn" style="display:none;"> 
            <td class="title">거래유무</td>
            <td><select name='commi_yn'>
                <option value="">전체</option>
                <option value="Y">유</option>
                <option value="N">무</option>
              </select></td>
            <td><a href="javascript:show_next('7');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr id="tr_check" style="display:none;"> 
      <td align="center">
		<a href="javascript:check_num();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_check_jb.gif" border="0" align="absbottom"></a>
        &nbsp; 
		<a href="javascript:check_double();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_check_or.gif" border="0" align="absbottom"></a>
		&nbsp;
        <a href="javascript:show_next('8');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_next.gif"  border="0" align="absbottom"></a> 
      </td>
    </tr>
    <tr>
      <td align="center">&nbsp;</td>
    </tr>
    <tr id="tr_search" style="display:none;"> 
      <td align="center"><a href="javascript:SearchCarOffP()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0" align="absbottom"></a></td>
    </tr>	
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

