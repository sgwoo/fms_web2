<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String senddate = request.getParameter("senddate")==null?"":request.getParameter("senddate");
	String cmid 	= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector resultList = umd.getSmsResult_msg_V5_req(cmid);
	
	int req_cnt = 0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		
		fm.new_msg.value = parent.document.form1.msg.value;
		
		var num = parseInt(parent.document.form1.msglen.value, 10);
		
		if(num >80){
			alert('80byte를 초과하여 전송할 수 없습니다.');
			return;			
		}
		
		if(confirm('수정하시겠습니까?')){
			fm.action = 'v5_req_list_in_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}	
	
	//삭제하기
	function sms_delete(){
		var fm = document.form1;
				
		if(confirm('삭제하시겠습니까?')){
			fm.action = 'v5_req_list_in_d_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}		
	}
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<input type='hidden' name='new_msg' 	value=''>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <%	if(resultList.size() !=0 ){
					for(int i=0; i< resultList.size(); i++){
						Hashtable ht = (Hashtable)resultList.elementAt(i);
						String status = (String)ht.get("STATUS");
						String rslt  =  (String)ht.get("CALL_RESULT");
						if(status.equals("0") && String.valueOf(ht.get("ETC1")).equals("req")){//대기
							req_cnt++;
%>
          <tr> 
		  
            <td width="100" align="center"><%= i+1 %></td>
            <td width="200" align="center"><input type="text" name="dest_name" value="<%= ht.get("DEST_NAME") %>" size="20" class=text></td>
            <td width="150" align="center"><input type="text" name="dest_phone" value="<%= ht.get("DEST_PHONE") %>" size="15" class=text></td>
            <td width="100" align="center">
              <%if(status.equals("0")) out.print("대기");
        														else if(status.equals("1")) out.print("발송중");
        														else if(status.equals("2")) out.print("발송완료");
        														else if(status.equals("3")) out.print("발송에러"); %>
            </td>
            <td width="100" align="center">
              <% if(rslt.equals("4100")) out.print("전달!");
        														else if(rslt.equals("4400")) out.print("음영지역");
        														else if(rslt.equals("4410")) out.print("잘못된전화번호");
        														else if(rslt.equals("4420")) out.print("기타에러");
        														else if(rslt.equals("4430")) out.print("수신거부"); %>
            </td>
            <td width="200" align="center">
			<input type="text" name="req_dt" size="10" class="text" value="<%= ht.get("REQ_DT") %>">
					  									<select name="req_dt_h">
                        									<%for(int j=0; j<24; j++){%>
                        									<option value="<%=AddUtil.addZero2(j)%>" <%if(String.valueOf(ht.get("REQ_DT_H")).equals(AddUtil.addZero2(j))){%>selected<%}%>><%=AddUtil.addZero2(j)%>시</option>
                        									<%}%>
                      									</select>
                      									<select name="req_dt_s">
                        									<%for(int j=0; j<59; j++){%>
                        									<option value="<%=AddUtil.addZero2(j)%>" <%if(String.valueOf(ht.get("REQ_DT_S")).equals(AddUtil.addZero2(j))){%>selected<%}%>><%=AddUtil.addZero2(j)%>분</option>
                        									<%}%>
                     									 </select>
														   <input type='hidden' name='cmid' 	value='<%= ht.get("CMID") %>'>
			</td>
            <td width="150" align="center"><%= AddUtil.ChangeDate3((String)ht.get("REPORT_TIME")) %></td>
          </tr>	
		  <%			}else{//그외
		  					%>
          <tr> 
            <td width="100" align="center"><%= i+1 %></td>
            <td width="200" align="center"><%= ht.get("DEST_NAME") %></td>
            <td width="150" align="center"><%= ht.get("DEST_PHONE")%></td>
            <td width="100" align="center">
              <%if(status.equals("0")) out.print("대기");
        														else if(status.equals("1")) out.print("발송중");
        														else if(status.equals("2")) out.print("발송완료");
        														else if(status.equals("3")) out.print("발송에러"); %>
            </td>
            <td width="100" align="center">
              <% if(rslt.equals("4100")) out.print("전달!");
        														else if(rslt.equals("4400")) out.print("음영지역");
        														else if(rslt.equals("4410")) out.print("잘못된전화번호");
        														else if(rslt.equals("4420")) out.print("기타에러");
        														else if(rslt.equals("4430")) out.print("수신거부"); %>
            </td>
            <td width="200" align="center"><%= AddUtil.ChangeDate3((String)ht.get("SEND_TIME")) %></td>
            <td width="150" align="center"><%= AddUtil.ChangeDate3((String)ht.get("REPORT_TIME")) %></td>
          </tr>
							
	  
		  <%			}%>
          <% 		}
				}else{ %>
          <tr> 
            <td colspan="7" align="center">해당 데이터가 없습니다. </td>
          </tr>
          <% 	} %>
          <tr>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
          </tr>		  
        </table></td>
  </tr>
  <%if(req_cnt>0){%>
  <tr>
    <td align="right"><a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
                &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:sms_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	</td>
  </tr>
  <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>