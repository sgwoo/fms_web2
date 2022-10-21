<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	AddUserMngDatabase umd = AddUserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	String dept_id 		= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	if(dept_id.equals("")){dept_id=acar_de;}
	String dept_ar[] = new String[1];
	int num = 0;
	dept_ar[0] = dept_id;
	
	if(dept_id.equals("0004")){//임원
		num = 1;
	}else if(dept_id.equals("0001")){//영업
		num = 3;
	}else if(dept_id.equals("0002")){//고객지원
		num = 4;
	}else if(dept_id.equals("0003")){//총무팀
		num = 5;
	}else if(dept_id.equals("0005")){//IT
		num = 6;
	}else if(dept_id.equals("0009")){//강남
		num = 7;
	}else if(dept_id.equals("0012")){//인천
		num = 8;
	}else if(dept_id.equals("0013")){//수원
		num = 9;
	}else if(dept_id.equals("0007")){//부산
		num = 10;
	}else if(dept_id.equals("0008")){//대전
		num = 11;
	}else if(dept_id.equals("0010")){//광주
		num = 12;
	}else if(dept_id.equals("0011")){//대구지점
		num = 13;
	}else if(dept_id.equals("0014")){//강서
		num = 14;
	}else if(dept_id.equals("0015")){//구로->부천
		num = 15;
	}else if(dept_id.equals("0020")){//영업기획팀
		num = 2;
	}else if(dept_id.equals("0017")){//강북
		num = 16;
	}else if(dept_id.equals("0018")){//송파
		num = 17;
	}


%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>무제 문서</title>
<style type=text/css>
<!--
.style1 {color: #848484}
.style2 {color: #424242}
.style3 {
	color: #0a3489;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript">
<!--
function move_page(st){  
		var fm = document.form1;
	
		if(st=='dept') 	fm.action = 'sawon_dept.jsp';
		
		fm.target = "_self";
		fm.submit();
	}



//-->
</script>
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<form action="sawon_dept.jsp" name="form1" method="POST">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > <span class=style5>조직도(부서별)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td align=right><a href="sawon.jsp" target=_self><img src=../images/center/button_jjb.gif border=0 align=absmiddle></a>&nbsp;&nbsp;<a href="sawon_sort.jsp" target=_self><img src=../images/center/button_isb.gif border=0 align=absmiddle></a>&nbsp; <img src=../images/center/arrow_bs.gif align=absmiddle>
   			<select name="dept_id" onChange="javascript:move_page('dept');">
   				<!--<option value="" <%if(dept_id.equals(""))%>selected<%%>>전체</option>-->
				<option value="0004" <%if(dept_id.equals("0004"))%>selected<%%>>임원</option>
				<option value="0001" <%if(dept_id.equals("0001"))%>selected<%%>>영업팀</option>
				<option value="0020" <%if(dept_id.equals("0020"))%>selected<%%>>영업기획팀</option>
				<option value="0002" <%if(dept_id.equals("0002"))%>selected<%%>>고객지원팀</option>
				<option value="0003" <%if(dept_id.equals("0003"))%>selected<%%>>총무팀</option>
				<option value="0005" <%if(dept_id.equals("0005"))%>selected<%%>>IT팀</option>
				<option value="0009" <%if(dept_id.equals("0009"))%>selected<%%>>강남지점</option>
				<option value="0012" <%if(dept_id.equals("0012"))%>selected<%%>>인천지점</option>
				<option value="0013" <%if(dept_id.equals("0013"))%>selected<%%>>수원지점</option>
				<option value="0007" <%if(dept_id.equals("0007"))%>selected<%%>>부산지점</option>
				<option value="0008" <%if(dept_id.equals("0008"))%>selected<%%>>대전지점</option>
				<option value="0010" <%if(dept_id.equals("0010"))%>selected<%%>>광주지점</option>
				<option value="0011" <%if(dept_id.equals("0011"))%>selected<%%>>대구지점</option>
				<option value="0014" <%if(dept_id.equals("0014"))%>selected<%%>>강서지점</option>
				<option value="0015" <%if(dept_id.equals("0015"))%>selected<%%>>부천지점</option>
				<option value="0017" <%if(dept_id.equals("0017"))%>selected<%%>>광화문지점</option>
				<option value="0018" <%if(dept_id.equals("0018"))%>selected<%%>>송파지점</option>
   			</select>
		</td>
    </tr>
    <tr>
        <td>
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
			<%for(int i =0;i<dept_ar.length; i++){
				Vector vt = umd.getSawonList(dept_ar[i]);
				int vt_size = vt.size();%>
                <tr>
			<td><%if(dept_id.equals("")){%><%}else{%>
			<font color='#846733'><b>[ <%=c_db.getNameById(dept_ar[i], "DEPT")%> ]</b></font>			
			<%}%></td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
            <!--임원 -->
                <tr>
                    <td>
                        <table width=100%  border=0 cellpadding=0 cellspacing=0>
						<% 	if(vt_size>0){
								for(int j = 0 ; j < vt_size;){
									Hashtable ht1 = (Hashtable)vt.elementAt(j);
									Hashtable ht2 = new Hashtable();
									if(j+1 < vt_size){
										ht2 = (Hashtable)vt.elementAt(j+1);
									}%>
									
                            <tr>
                                <td width=49%>
                                    <table width=100%  border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=103 align=center>
                                                <table width=87  border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF><img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht1.get("SAVE_FOLDER")%><%=ht1.get("FILE_NAME")%>" border="0" width="85" height="105"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor=e9e9e9>
                                                    <tr>
                                                        <td style='height:105' align=center bgcolor=#FFFFFF>
                                                            <table width=98% border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                                <tr>
                                                                    <td width=20% height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">성 명</td>
                                                                    <td width=30% bgcolor=#FFFFFF style='color:0a3489'>&nbsp;<b><%if(String.valueOf(ht1.get("USER_ID")).equals(ck_acar_id)){%><a href="javascript:UserUpdate('<%= ht1.get("USER_ID") %>','<%//=auth_rw%>')"><%=ht1.get("USER_NM")%></a><%}else{%><%=ht1.get("USER_NM")%><%}%></b></td>
                                                                    <td width=20% align=center style="background-color:#eaeaea; height:24; color:848484;">직 급</td>
                                                                    <td width=30% bgcolor=#FFFFFF>&nbsp;<%=ht1.get("USER_POS")%></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">나 이</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;만<%=ht1.get("AGE")%>세</td>
                                                                    <td align=center style="background-color:#eaeaea; height:24; color:848484;">입사일</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("ENTER_DT")%></td>
                                                                </tr>
                                                                <tr>
																	<td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">핸드폰</td>
																	<td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("USER_M_TEL")%></td>
																	<td align=center style="background-color:#eaeaea; height:24; color:848484;">직통번호</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("HOT_TEL")%></td>
                                                                </tr>
                                                                <tr>
																	<td align=center style="background-color:#eaeaea; height:24; color:848484;">내선번호</td>
																	<td bgcolor=#FFFFFF>&nbsp;<%=ht1.get("IN_TEL")%></td>
																	<td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">업무</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%if(String.valueOf(ht1.get("LOAN_ST")).equals("1")){%>관리<%}else if(String.valueOf(ht1.get("LOAN_ST")).equals("2")){%>영업<%}%></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=2% align=center>&nbsp;</td>
                                <td width=49%>
								<%if(j+1 < vt_size){%>
                                    <table width=100%  border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=103 align=center>
                                                <table width=87  border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF><img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht2.get("SAVE_FOLDER")%><%=ht2.get("FILE_NAME")%>" border="0" width="85" height="105"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor=e9e9e9>
                                                    <tr>
                                                        <td style='height:105' align=center bgcolor=#FFFFFF>
                                                            <table width=98% border=0 cellpadding=0 cellspacing=1 bgcolor=cfcfcf>
                                                                <tr>
                                                                    <td width=20% height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">성 명</td>
                                                                    <td width=30% bgcolor=#FFFFFF style='color:0a3489'>&nbsp;<b><%=ht2.get("USER_NM")%></b></td>
                                                                    <td width=20% align=center style="background-color:#eaeaea; height:24; color:848484;">직 급</td>
                                                                    <td width=30% bgcolor=#FFFFFF>&nbsp;<%=ht2.get("USER_POS")%></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">나 이</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;만<%=ht2.get("AGE")%>세</td>
                                                                    <td align=center style="background-color:#eaeaea; height:24; color:848484;">입사일</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("ENTER_DT")%></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">핸드폰</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("USER_M_TEL")%></td>
																	<td align=center style="background-color:#eaeaea; height:24; color:848484;">직통번호</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("HOT_TEL")%></td>
                                                                </tr>
                                                                <tr>
                                                                	
                                                                  <td align=center style="background-color:#eaeaea; height:24; color:848484;">내선번호</td>
                                                                  <td bgcolor=#FFFFFF>&nbsp;<%=ht2.get("IN_TEL")%></td>
																  <td height=24 align=center style="background-color:#eaeaea; height:24; color:848484;">업무</td>
                                                                    <td bgcolor=#FFFFFF>&nbsp;<%if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){%>관리<%}else if(String.valueOf(ht2.get("LOAN_ST")).equals("2")){%>영업<%}%></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>									
								<%}%>
                                </td>
                            </tr>
			                <tr>
            			        <td colspan="3" class=h></td>
			                </tr>							
						    <%	j+=2;}}%>	
                        </table>
                    </td>
                </tr>
             <!--임원 -->
                <tr>
                    <td style='height:30'></td>
                </tr>
			<%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
