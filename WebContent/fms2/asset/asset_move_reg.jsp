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
		
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//�ڻ� ���� 
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
	//�����ϱ�
	function save(){
		var fm = document.form1;
		
		if(fm.assch_date.value == ''){	alert('�������ڸ� �Է��Ͻʽÿ�.'); return;}		
		
		if(fm.cap_amt.value == ''){	alert('����ݾ��� �Է��ϼ���.'); return;}			
				
		//�����ϰ� ����� Ʋ����� üũ  s_str.substring(0,4)
		if ( fm.assch_date.value.substring(0,4)  != fm.gisu.value  ) {
			alert('�ش� ��� �ڻ����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
			return;
		}
		
		// �ڻ�� ��� ���߱�
//		if ( toInt(replaceString("-","",fm.assch_date.value)) > 20171231 ) {
/*
		if ( toInt(replaceString("-","",fm.assch_date.value)) <= 20171231	) {
			alert('2018�� �ڻ����θ� �ڻ�ó���� �� �ֽ��ϴ�.');
			return;
		}
*/
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=car_no%> ���� ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width="80">��������</td>
                    <td> 
                    <input type="text" name="assch_date"  type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">��������</td>
                    <td><select name="assch_type">
                  
                        <option value="1" >�ں�������</option>
                   
                        </select>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">����</td>
                    <td> 
                    <input type="text" name="assch_rmk"   size="50" class=text style='IME-MODE: active'>
                    </td>
              </tr>
              <tr> 
                    <td class=title width="80">����ݾ�</td>
                    <td> 
                    <input type="text" name="cap_amt"   size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
              </tr>
            
            </table>
        </td>
    </tr>
    <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ڻ����",user_id)){%>
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
