<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 5; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function EstiReg()
{	
	var SUBWIN="./esti_mng_i.jsp";	
	window.open(SUBWIN, "EstiReg", "left=100, top=100, width=580, height=200, scrollbars=no");
}

function UpdateList(arg)
{	
	var theForm = document.CarOffUpdateForm;
	theForm.car_off_id.value = arg;
	theForm.target="d_content";
	theForm.submit();
}

	//전체선택
	function AllSelect(){
		var fm = EstiList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}	
	
	//선택견적
	function select_esti(){
		var fm = EstiList.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적할 차량을 선택하세요.");
			return;
		}	

		if(cnt > 3){
		 	alert("견적 건수가 많습니다. 최대 3개 입니다.");
			return;
		}	

		if(confirm('선택한 차량을 견적하시겠습니까?')){
			fm.target = "i_no";						
			fm.action = "w_select_car_esti_proc.jsp";
	//		fm.action = "http://cms.amazoncar.co.kr:8080/acar/admin/w_select_car_esti_proc.jsp";   //104번 서버
			fm.submit();	
		}
	}		
//-->
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">    
    <tr> 
      <td>	  
	   <a href="javascript:select_esti();" title='선택견적'>[선택견적]</a> (최대 3개 선택 가능)
	  </td>
    </tr>  
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class="line" width=100%>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td width=3% rowspan="3" class="title">연번</td>
                                <td width=3% rowspan="3" class="title"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                                <td width=4% rowspan="3" class="title">우선<br>순위</td>
                                <td width=12% rowspan="3" class="title">차종</td>
                                <td width=4% rowspan="3" class="title">변속기<br>/신용</td>
                                <td width=5% rowspan="3" class="title">연료</td>
                                <td width=6% rowspan="3" class="title">차량가격</td>
                                <td width=5% rowspan="3" class="title">DC금액</td>
                                <td width=3% rowspan="3" class="title">차종<br>코드</td>				
                                <td width=3% rowspan="3" class="title">사용<br>여부</td>
                                <td width=3% rowspan="3" class="title">계약<br>개월</td>
                                <td colspan="2" class="title">장기렌트</td>
                                <td colspan="2" class="title">오토리스</td>
                                <td colspan="2" class="title">오토리스</td>				
                                <td width=7% rowspan="3" class="title">견적</td>
                            </tr>
                            <tr> 
                                <td class="title">기본식</td>
                                <td class="title">일반식</td>
                                <td class="title">기본식</td>
                                <td class="title">일반식</td>
                                <td class="title">기본식</td>
                                <td class="title">일반식</td>
                            </tr>
                            <tr>
                                <td width=14% colspan="2" class="title">(보험료 포함)</td>
                                <td width=14% colspan="2" class="title">(보험료 포함)</td>
                                <td width=14% colspan="2" class="title">(보험료 미포함)</td>
                            </tr>
                        </table>
                    </td>			        
                </tr>
            </table>
        </td>
        <td width='17'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=2>
            <iframe src="./main_car_sc_in.jsp?auth_rw=<%=auth_rw%>&base_dt=<%= base_dt %>&car_comp_id=<%= car_comp_id %>&t_wd=<%= t_wd %>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe>
        </td>
    </tr>
</table>

</body>
</html>