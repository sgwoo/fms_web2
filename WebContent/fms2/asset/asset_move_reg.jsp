<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="bean" class="acar.asset.AssetMaBean" scope="page"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
		
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//자산 정보 
	AssetDatabase a_db = AssetDatabase.getInstance();
	bean = a_db.getAssetMa(asset_code);
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		
		if(fm.assch_date.value == ''){	alert('변동일자를 입력하십시오.'); return;}		
		
		if(fm.cap_amt.value == ''){	alert('지출금액을 입력하세요.'); return;}			
				
		//변동일과 기수가 틀린경우 체크  s_str.substring(0,4)
		if ( fm.assch_date.value.substring(0,4)  != fm.gisu.value  ) {
			alert('해당 기수 자산으로만 자산처리할 수 있습니다.');
			return;
		}
		
		// 자산상각 기수 맞추기
//		if ( toInt(replaceString("-","",fm.assch_date.value)) > 20171231 ) {
/*
		if ( toInt(replaceString("-","",fm.assch_date.value)) <= 20171231	) {
			alert('2018년 자산으로만 자산처리할 수 있습니다.');
			return;
		}
*/
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = 'asset_move_reg_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
-->	
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.assch_date.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='asset_code' value='<%=asset_code%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type="hidden" name="gisu" value="<%=bean.getGisu()%>">

<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 변동 내역</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width="80">변동일자</td>
                    <td> 
                    <input type="text" name="assch_date"  type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">변동구분</td>
                    <td><select name="assch_type">
                  
                        <option value="1" >자본적지출</option>
                   
                        </select>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">내역</td>
                    <td> 
                    <input type="text" name="assch_rmk"   size="50" class=text style='IME-MODE: active'>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">지출금액</td>
                    <td> 
                    <input type="text" name="cap_amt"   size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
              </tr>
            
            </table>
        </td>
    </tr>
    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자산관리",user_id)){%>
    <tr> 
        <td align="right"><a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
   <% } %> 
</table>  
  </form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
