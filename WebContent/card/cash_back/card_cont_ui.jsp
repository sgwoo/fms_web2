<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String s_card 	= request.getParameter("s_card")==null?"":request.getParameter("s_card");
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "/card/cash_back/cash_back_frame.jsp");
	
	//ī������
	CardBean c_bean = CardDb.getCard(cardno);
	
	//ī���������
	CardContBean cont_bean = CardDb.getCardCont(cardno, seq);	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�׿�����ȸ
	function Card_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		if(s_kd == 'agnt_nm')	fm.t_wd.value = fm.agnt_nm.value;
		if(s_kd == 'master_nm')	fm.t_wd.value = fm.master_nm.value;
		if(s_kd == 'n_ven')		fm.t_wd.value = fm.card_kind.value;
		window.open("about:blank",'Card_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');
		fm.action = "card_search.jsp";
		fm.target = "Card_search";
		fm.submit();		
	}
	function Card_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Card_search(s_kd);
	}	

	//����
	function Save(){
		var fm = document.form1;
		
		if(fm.cardno.value == '')	{ alert('�ſ�ī�尡 ���õ��� �ʾҽ��ϴ�.'); return; }
		if(fm.cont_dt.value == '')	{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }
		//if(fm.give_day.value == '')	{ alert('�ſ�����ϼ��� �Է��Ͻʽÿ�.'); return; }
		//if(fm.cont_amt.value == '' || fm.cont_amt.value == '0')	{ alert('�ſ��ѵ��� �Է��Ͻʽÿ�.'); return; }
		if(fm.allot_link_yn[0].checked == false && fm.allot_link_yn[1].checked == false)	{alert('���⿬�迩�θ� �����Ͻʽÿ�.');return;}
		if(fm.save_per1.value == '' || fm.save_per1.value == '0')	{ alert('Cash back �Ϲ� �������� �Է��Ͻʽÿ�.'); return; }
		if(fm.allot_link_yn[1].checked == true && (fm.save_per2.value == '' || fm.save_per2.value == '0'))	{ alert('Cash back ���⿬�� �������� �Է��Ͻʽÿ�.'); return; }
		//if(fm.agnt_nm.value == '')	{ alert('����� �̸��� �Է��Ͻʽÿ�.'); return; }
		//if(fm.agnt_tel.value == '')	{ alert('����� ����ó�� �Է��Ͻʽÿ�.'); return; }
		//if(fm.agnt_m_tel.value == '')	{ alert('����� �ڵ����� �Է��Ͻʽÿ�.'); return; }
		
		<%if(!seq.equals("")){%>
			if(fm.reg_type[0].checked == false && fm.reg_type[1].checked == false)	{alert('���汸���� �����Ͻʽÿ�.');return;}
		<%}%>	
		
		var ment = "�����Ͻðڽ��ϱ�?";
		
		if(fm.seq.value == ''){
			ment = "����Ͻðڽ��ϱ�?";
		}
		
		if(confirm(ment)){
			fm.action='card_cont_ui_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
		
	function Close(){
		window.close();
	}

//-->
</script>

</head>
<body topmargin="10" <%if(cardno.equals("")){%>onload="javascript:document.form1.cardno.focus();"<%}%>>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='go_url' value='/card/cash_back/card_cont_ui.jsp'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='s_card' value='<%=s_card%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='mode' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�濵���� > �繫ȸ�� > <span class=style5>Cash back ���� <%if(seq.equals("")){%>���<%}else{%>����<%}%> [<%=c_db.getNameByIdCode("0031", card_kind, "")%>] </span></span></td>
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
              <td width='20%'  class='title'>�ſ�ī���ȣ</td>
              <td>&nbsp;
              	<%if(cardno.equals("")){%>
                  <input name="cardno" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javasript:Card_enter('cardno')"> 
				          <a href="javascript:Card_search('cardno');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
				        <%}else{%>  
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" redeonly>				        
				        <%}%>
              </td>
            </tr>
            <tr>
              <td width='20%'  class='title'>ī�屸��</td>
              <td>&nbsp;
				        <input name="card_paid" type="text" class="whitetext" value="<%if(c_bean.getCard_paid().equals("2")){%>����ī��<%}else if(c_bean.getCard_paid().equals("3")){%>�ĺ�ī��<%}else if(c_bean.getCard_paid().equals("5")){%>����Ʈ<%}else if(c_bean.getCard_paid().equals("7")){%>ī���Һ�<%}%>" size="30" redeonly>
              </td>
            </tr>            
            <tr>
              <td width='20%'  class='title'>����ڱ���</td>
              <td>&nbsp;
				        <input name="card_name" type="text" class="whitetext" value="<%=c_bean.getCard_name()%>" size="30" redeonly>
              </td>
            </tr>            
		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%' class='title'>��������</td>
              <td>&nbsp;
                  <input name="cont_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cont_bean.getCont_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>�ſ�����ϼ�</td>
              <td>&nbsp;
                  <input type="text" name="give_day" size="2" value="<%=cont_bean.getGive_day()%>" class=num> ��
                  &nbsp;&nbsp;&nbsp;
                  <input type='radio' name="give_day_st" value='1' <%if(cont_bean.getGive_day_st().equals("") || cont_bean.getGive_day_st().equals("1"))%>checked<%%>>
        				  ������
        	        <input type='radio' name="give_day_st" value='2' <%if(cont_bean.getGive_day_st().equals("2"))%>checked<%%>>
        				  �޷���
			  </td>
            </tr>
            <tr>
              <td class='title'>�ſ��ѵ�</td>
              <td>&nbsp;
                  <input type="text" name="cont_amt" size="15" value="<%=AddUtil.parseDecimalLong(cont_bean.getCont_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      		��</td>
            </tr>         
            <tr>
              <td class='title'>���⿬�迩��</td>
              <td>&nbsp;
              	  <input type='radio' name="allot_link_yn" value='N' <%if(cont_bean.getAllot_link_yn().equals("N"))%>checked<%%>>
        				  ����
        	        <input type='radio' name="allot_link_yn" value='Y' <%if(cont_bean.getAllot_link_yn().equals("Y"))%>checked<%%>>
        				  �ִ�
              </td>
            </tr>
            <tr>
              <td class='title'>Cash back ������</td>
              <td>&nbsp;
                  �Ϲ� : <input type="text" name="save_per1" size="4" value="<%=cont_bean.getSave_per1()%>" class=num>%
                  &nbsp;
                  (����ī��,ī���Һ�)
                  ���⿬�� : <input type="text" name="save_per2" size="4" value="<%=cont_bean.getSave_per2()%>" class=num>%
      		    </td>
            </tr>
            <tr>
              <td rowspan='2' class='title'>������ �Աݿ�����</td>
              <td>&nbsp;
              	  <input type="checkbox" name="save_in_dt_st1" value="Y" <%if(cont_bean.getSave_in_dt_st1().equals("Y"))%>checked<%%>>
                  ����
                  <input type="checkbox" name="save_in_dt_st2" value="Y" <%if(cont_bean.getSave_in_dt_st2().equals("Y"))%>checked<%%>>
                  ������
                  <input type="checkbox" name="save_in_dt_st3" value="Y" <%if(cont_bean.getSave_in_dt_st3().equals("Y"))%>checked<%%>>
                  �ſ� 
                  <input type="text" name="save_in_dt" size="2" value="<%=cont_bean.getSave_in_dt()%>" class=num>��
              </td>
            </tr>
            <tr>
              <td>&nbsp;
              	  <textarea rows='2' cols='90' name='save_in_st'><%=cont_bean.getSave_in_st()%></textarea>
              </td>
            </tr>
            <tr>
              <td class='title'>�����</td>
              <td>&nbsp;
              	  <a href="javascript:Card_search('agnt_nm');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              	  &nbsp;
                  �̸� : <input type="text" name="agnt_nm" size="10" value="<%=cont_bean.getAgnt_nm()%>" class=text> 
                  &nbsp;
                  ����ó : <input type="text" name="agnt_tel" size="15" value="<%=cont_bean.getAgnt_tel()%>" class=text>
                  &nbsp;
                  �ڵ��� : <input type="text" name="agnt_m_tel" size="15" value="<%=cont_bean.getAgnt_m_tel()%>" class=text>
              </td>
            </tr>
            <tr>
              <td class='title'>������</td>
              <td>&nbsp;
              	  <a href="javascript:Card_search('master_nm');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
              	  &nbsp;
                  �̸� : <input type="text" name="master_nm" size="10" value="<%=cont_bean.getMaster_nm()%>" class=text> 
                  &nbsp;
                  ����ó : <input type="text" name="master_tel" size="15" value="<%=cont_bean.getMaster_tel()%>" class=text>
                  &nbsp;
                  �ڵ��� : <input type="text" name="master_m_tel" size="15" value="<%=cont_bean.getMaster_m_tel()%>" class=text>
              </td>
            </tr>
            <tr>
              <td class='title'>����</td>
              <td>&nbsp;
                  <textarea rows='2' cols='90' name='etc'><%=cont_bean.getEtc()%></textarea>
              </td>
            </tr>
            <tr>
              <td class='title'>�Աݿ��� ����</td>
              <td>&nbsp;
                  <a href="javascript:Card_search('n_ven');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
                  &nbsp;
                  �ŷ�ó�ڵ� : <input type="text" name="n_ven_code" size="10" value="<%=cont_bean.getN_ven_code()%>" class=text readonly> 
                  &nbsp;
                  �ŷ�ó�� : <input type="text" name="n_ven_name" size="25" value="<%=cont_bean.getN_ven_name()%>" class=text readonly>
              </td>
            </tr>            
            <%if(!seq.equals("")){%>
            <tr>
              <td class='title'>���汸��</td>
              <td>&nbsp;
                  <input type='radio' name="reg_type" value='H'>
        				  ����(�̷°���)
        	        <input type='radio' name="reg_type" value='U'>
        				  ��������
              </td>
            </tr>
            <%}%>

          </table></td>
  </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("6")) {%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_<%if(seq.equals("")){%>reg<%}else{%>modify<%}%>.gif border=0 align=absmiddle></a>
        &nbsp;
        <%}%>
	      <a href="javascript:Close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
