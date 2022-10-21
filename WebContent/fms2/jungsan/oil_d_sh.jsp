<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*, acar.util.*,  acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String sort		= request.getParameter("sort")==null?"":request.getParameter("sort");
			
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");		
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
		
//	int cnt = 2; //현황 출력 총수
//	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 100;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script language="JavaScript">

var delay = 2000;
var submitted = false;

(function() {

  // doubleFlag는 처음에 false로 초기화 한다.
  var doubleFlag = false;
  
  // 더블 클릭 함수 생성
  this.doubleCheck = function doubleCheck() {
    if(doubleFlag == true) {
      return doubleFlag;
    } else {
      doubleFlag = true;
      return false;
    }
  }

  // 더블 클릭된 이벤트가 발생이후 다시 버튼을 초기화 하기 위해 사용된다.
  this.clickInitial = function clickInitial() {
    doubleFlag = false;
  }
})();

// 클릭 이벤트
function clickSubmit() {
	var fm = document.form1;
	
	if(fm.dt[2].checked == false)
	{ 
		alert('조회기간을  선택하세요.');
		return;
	}
	
	if ( fm.ref_dt1.value == ""  )
	{ 
		alert('조회기간을  입력하세요.');
		return;
	}	
	if ( fm.ref_dt2.value == "" )
	{ 
		alert('조회기간을  입력하세요.');
		return;
	}
	
  // 더블 클릭한 경우
   if(doubleCheck() == true) {

	alert('처리 중입니다. 잠시만 기다려주세요');
    // 다시 정상적으로 클릭이벤트가 발생 할 수 있도록 초기화 요청
    clickInitial();
    return;
   }
  // 한번만 클릭한 경우
  else {
    makeCarOil();
  }
}

function makeCarOil()
{
	var fm = document.form1;
	
	fm.action="oil_d_make.jsp?make=Y";		
	fm.target="i_no";		
	fm.submit();
		
}


function Search()
{
	var fm = document.form1;
	
	if(fm.dt[0].checked == false && fm.dt[1].checked == false && fm.dt[2].checked == false)
	{ alert('조회항목을  선택하십시오.'); return;}
	
	fm.action="oil_d_sc.jsp";		
	fm.target="cd_foot";		
	fm.submit();
		
}

function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


function submitCheck() {

	 var fm = document.form1;
	
	 if(fm.dt[0].checked == false && fm.dt[1].checked == false && fm.dt[2].checked == false)
	 { alert('조회항목을  선택하십시오.'); return;}
	
	 if(fm.dt[2].checked == true ) {
		 if ( fm.ref_dt1.value == ""  )
		{ 	alert('조회기간을  입력하세요.');return;		}	
			if ( fm.ref_dt2.value == "" )
		{ 	alert('조회기간을  입력하세요.');	return;		}
      }	
	
	  if(submitted == true) { return; }

	  document.form1.srch.value = '검색중';
	  document.form1.srch.disabled = true;
	  
	  setTimeout ('Search()', delay);
	  
	  submitted = true;
	}

	function submitInit() {

		  document.form1.srch.value = '검색';
		  document.form1.srch.disabled = false;
		   
		  submitted = false;
		}

	
</script>

</head>
<body>
<form  name="form1" method="POST">
 
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <input type='hidden' name="height" value="<%=height%>">  

  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>현황 및 통계 > 재무회계 > <span class=style5>업무용차량 연료비 사용현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
              <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              최근 5년 
                 <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
              최근 1년 
              <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
              조회기간
			  &nbsp;&nbsp;
				<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
              <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
		  
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jr.gif  align=absmiddle>
              <input type="radio" name="sort" value="" <%if(sort.equals(""))%>checked<%%>>
              전체 
              <input type="radio" name="sort" value="1" <%if(sort.equals("1"))%>checked<%%>>
      LPG      
              <input type="radio" name="sort" value="2" <%if(sort.equals("2"))%>checked<%%>>
              경유·휘발유
              <input type="radio" name="sort" value="3" <%if(sort.equals("3"))%>checked<%%>>
              전기·수소        
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <!-- <a id="submitLink" href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>   -->
		 <input type="button" onClick="Search();" value="검색"/>&nbsp;&nbsp;&nbsp;&nbsp;  
		    	    
		<!-- 	 
		 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="srch" value="검색" onclick="submitCheck();">  		 
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <input type="button" name="init" value="버튼초기화" onclick="submitInit();">  -->
         <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("제안참석팀장",user_id) ) { %>           
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" onClick="clickSubmit();" value="데이타생성"/>
            <% } %>
        
			  </td>
             </tr>  
        </table>
      </td>
   
    </tr>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>