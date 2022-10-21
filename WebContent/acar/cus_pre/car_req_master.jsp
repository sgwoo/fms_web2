<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id"); 
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); //담당자
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id"); 
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); //계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	

//	String gubun = "Y";
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");
		
	String m1_content="";
		
	//차량정보
	Hashtable res = rs_db.getCarMaintInfo(c_id);	
	
     if (!String.valueOf(res.get("M1_CONTENT")).equals("") && !String.valueOf(res.get("M1_CHK")).equals("")    )  {
          m1_content = String.valueOf(res.get("M1_CONTENT"));         
     } else {
              if ( gubun.equals("Y")) {
               m1_content=" 차령연장용 임시검사의뢰합니다. 자동차등록증 원본과 검사신청서가 없을 경우 연락주세요 - 담당자 류길선  Tel)02-6263-6368";
              }         
     }
                     
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		if( fm.m1_chk.value == '1' ) {
			alert("마스타자동차에 의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
			return;
		}	
		
		if( fm.m1_chk.value == '5' ) {
			alert("에프엔티코리아에 의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
			return;
		}
		
		if( fm.m1_chk.value == '6' ) {
			alert("미스터박대리에 의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
			return;
		}
		
		if( fm.gubun.value == 'Y'  ) {
		    if (  fm.m1_chk.value == '3' ||   fm.m1_chk.value == '8' ||   fm.m1_chk.value == 'A' ) {
		     }  else {
			alert("성수검사소, 차비서 , 성서현대 이외에  의뢰할 수 없습니다. 다시 확인하여 등록하세요..!!");
			return;
		     }	
		}			
		
		if( fm.m1_chk.value == '' ) {
			alert("의뢰내역을 선택하세요..!!");
			return;
		}
		
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'car_req_master_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" >
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<table border=0 cellspacing=0 cellpadding=0 width=500>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> 차량 검사의뢰 등록</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="25%">의뢰</td>
                    <td>&nbsp;
                    
 <%  if ( !String.valueOf(res.get("M1_CHK")).equals("")    )  {   %>                
                    <SELECT NAME="m1_chk" >                    	
                     			<option value="0" <%if( res.get("M1_CHK").equals("0"))%> selected<%%>>해당사항 없음</option>
                      		   <option value="1" <%if( res.get("M1_CHK").equals("1"))%> selected<%%>>마스타자동차 검사의뢰 요청</option>   
                    		   <option value="2" <%if( res.get("M1_CHK").equals("2"))%> selected<%%>>담당자가 직접 검사진행</option> 
                    		   <option value="3" <%if( res.get("M1_CHK").equals("3"))%> selected<%%>>성수자동차 검사의뢰 요청</option>                     		
                    		   <option value="5" <%if( res.get("M1_CHK").equals("5"))%> selected<%%>>에프앤티코리아 검사의뢰 요청</option> 
                    		   <option value="6" <%if( res.get("M1_CHK").equals("6"))%> selected<%%>>미스터박대리 검사의뢰 요청</option> 
                    		    <option value="8" <%if( res.get("M1_CHK").equals("8"))%> selected<%%>>차비서 검사의뢰 요청</option> 
                    		     <option value="A" <%if( res.get("M1_CHK").equals("A"))%> selected<%%>>성서현대(대구) 검사의뢰 요청</option> 
                    		 
        		        </SELECT>
 <% } else { %>       		        
        		           <SELECT NAME="m1_chk" >
                    			<option value="" > --선택 -- </option>
                     			<option value="0" > 해당사항 없음</option>                      		 
                    		   <option value="2" >담당자가 직접 검사진행</option> 
                    		   <option value="3" >성수자동차 검사의뢰 요청</option>   
                    		   <option value="8" >차비서 검사의뢰 요청</option>    
                    		   <option value="A" >성서현대(대구) 검사의뢰 요청</option>                  		
                    		 
        		        </SELECT>
<% } %>        		        
        		         <%if( res.get("M1_CHK").equals("1")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("2")) {%> 등록일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("3")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("5")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("6")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        		         <%if( res.get("M1_CHK").equals("8")) {%> 의뢰일 : <%=AddUtil.ChangeDate2((String)res.get("M1_DT"))%><% } %>  
        	        </td>
    		    </tr>	
    		  
    		    <tr> 
                    <td class=title  width="25%" >요구사항</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='m1_content' rows='3' cols='60' ><%=m1_content%></textarea>
                    </td>
                </tr>	
                <tr> 
                    <td class=title  width="25%" >진행 특이사항 <br> (대행업체)</td>
                    <td colspan="2" >&nbsp; 
                     <textarea name='che_remark' rows='3' cols='60' readonly ><%=(String)res.get("CHE_REMARK") %></textarea>
                    </td>
                </tr>	
                
               
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
         <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
          <%  if ( String.valueOf(res.get("M1_CHK")).equals("")    )  {   %>                 
        <% //if( !res.get("M1_CHK").equals("1") && !res.get("M1_CHK").equals("2") && !res.get("M1_CHK").equals("3")  && !res.get("M1_CHK").equals("5") ){ %>
        <input type='checkbox' name="sms_yn" value='Y' >차량이용자에게 자동 안내 문자 발송
        <a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
        <% } %> 
        <% } %>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    
    <tr>
    	<td><font color=red>&nbsp;**</font>&nbsp;대행업체에  검사의뢰 등록하세요!!! <br>차령연장 임시검사는 우선 성수검사소에서만 진행합니다. <br>지점은  담당자가 진행합니다.<br>
    		    <font color=red>&nbsp;**</font>&nbsp;차량이용자가 미등록되어 있는 경우  문자가 발송되지 않습니다. 발송을 원할 경우 목록에서 핸드폰 아이콘을 눌러서 발송할 수 있습니다!!!
       </td>
    <tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
