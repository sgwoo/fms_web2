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
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	
		
		
	
	//�õ�
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
//�з����м��ý� �����ܰ� �����ֱ�
function show_next(arg){
	var fm = document.form1;
	//var rlt = fm.result.value;
	
	if(arg=='1'){
		if(fm.gubun.value=='1'){	//�����ϰ��,�ڵ���ȸ��� ��ü���Ѵ�. �׸��� �����õ� ���ú����ش�.
			tr_cc_id.style.display = "";
			//fm.cc_id.disabled = true;
			tr_sido.style.display = "";
			//fm.result.value =  rlt+", "+"";
			fm.sido.focus();
		}else if(fm.gubun.value=='2'){	//�ڵ���ȸ���ϰ��, 
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
		//������ ��� ��Ÿ����
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
		//������ ��� ��Ÿ����
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

//�������п� ���� ��,�� �˻�
function getGugunAll(){
	fm = document.form1;
	//���������� ����
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

//�ʱ�ȭ
function init(){
	opener.smsList.location.href = "./sms_list.jsp";
	location.href = "./target_search.jsp";
}

//�˻���� �θ������쿡�� �����ֱ�
function SearchCarOffP(){
	fm = document.form1;
	opener.smsList.smsList_t.location.href = "./sms_list_t.jsp";
	fm.target = "smsList_in";
	fm.action = "./sms_list_in.jsp";
	fm.submit();
}
//�ߺ��� ��ȸ
function check_double(){
	window.open("about:blank", "check_double", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	fm.target = "check_double";
	fm.action = "./sms_list_double.jsp";
	fm.submit();
}
//��ȣ����üũ
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
            <td width="110" class="title">�߼۴��</td>
            <td colspan="2">&nbsp;�������</td>
          </tr>
          <tr> 
            <td class="title">�߼۹��</td>
            <td colspan="2">&nbsp;����</td>
          </tr>
          <tr> 
            <td colspan="3"><font color="#666666">�ذ˻���ư�� ��Ÿ�� ������ ������ �ֽñ� �ٶ��ϴ�.</font></td>
          </tr>
          <tr> 
            <td class="title">�����</td>
            <td colspan="2"><select name='s_bus'>
                <option value="">=��ü=</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
              </select></td>
          </tr>
          <tr> 
            <td class="title">�з����� </td>
            <td colspan="2"><select name='gubun' onChange="javascript:show_next('1');">
                <option value="">����</option>
                <option value="1">����</option>
                <option value="2">�ڵ���ȸ��</option>
              </select></td>
          </tr>
          <tr id="tr_cc_id" style="display:none;"> 
            <td class="title">�ڵ���ȸ��</td>
            <td colspan="2"><select name="cc_id" onChange="javascript:show_next('2');">
                <option value="">��ü 
                <%
			for(int i=0; i<cc_r.length; i++){
				cc_bean = cc_r[i];
		%>
                <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                <%	}%>
              </select></td>
          </tr>
          <tr id="tr_sido_result" style="display:none;"> 
            <td class="title">����(������,��)</td>
            <td colspan="2"><input type="text" class="whitetext" name="sido_result" size="28"></td>
          </tr>
          <tr id="tr_sido" style="display:none;"> 
            <td class="title">����(������,��)<br> <br>
              �� �������ù��:<br>
              Ctrl Ű + ���콺���ʹ�ư</td>
            <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">

                <tr> 
                  <td width="72%"><select name="sido" multiple size="8">
                      <option value="">--��ü--</option>
                      <option value="1">����</option>
                      <option value="2">����</option>
                      <option value="3">����,�泲,���</option>
                      <option value="4">��õ,���</option>
                      <option value="5">����,����,����</option>
                      <option value="6">�λ�,���,�泲,����</option>
                      <option value="7">�뱸,���</option>
                    </select> </td>
                  <td width="28%"><a href="javascript:show_next('3');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr id="tr_gugun_result" style="display:none;"> 
            <td class="title">����(���ʱ�, ��)</td>
            <td colspan="2"><input type="text" class="whitetext" name="gugun_result" size="28"></td>
          </tr>
          <tr id="tr_gugun" style="display:none;"> 
            <td class="title">����(���ʱ�, ��)<br> <br>
              �� �������ù��:<br>
              Ctrl Ű + ���콺���ʹ�ư</td>
            <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="72%"><select name="gugun" multiple size="10">
                      <option value="��ü">--��ü--</option>
                    </select> </td>
                  <td width="28%"><a href="javascript:show_next('4');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
                </tr>
              </table></td>
          </tr>
          <tr id="tr_send_gubun" style="display:none;"> 
            <td class="title">�߼۱���</td>
            <td width="148"><select name='send_gubun' multiple size="9">
                <option value="">��ü</option>
                <% for(int i=0; i< umd.getMax_gubun(); i++){ %>
                <option value="<%= i+1 %>"><%= i+1 %></option>
                <% } %>
              </select></td>
            <td width="59"><a href="javascript:show_next('5');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
          </tr>
          <tr id="tr_cng_rsn" style="display:none;">
            <td class="title">��������</td>
            <td><select name="cng_rsn">
                <option value="">==��ü==</option>
                <option value="1">1.�ֱٰ��</option>
                <option value="2">2.�����</option>
                <option value="3">3.���ʵ��</option>
                <option value="4">4.SMS����</option>
                <option value="5">5.��Ÿ</option>
              </select></td>
            <td><a href="javascript:show_next('6');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_next.gif"  border="0" align="absbottom"></a></td>
          </tr>
          <tr id="tr_commi_yn" style="display:none;"> 
            <td class="title">�ŷ�����</td>
            <td><select name='commi_yn'>
                <option value="">��ü</option>
                <option value="Y">��</option>
                <option value="N">��</option>
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

