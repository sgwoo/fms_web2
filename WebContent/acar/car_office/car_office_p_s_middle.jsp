<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="line"><table width="800" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="88" rowspan="2" class="title">������</td>
          <td width="84" class="title">�Ҽӻ�</td>
          <td width="224">&nbsp; 
            <%for(int i=0; i<cc_r.length; i++){
							cc_bean = cc_r[i];
							if(cc_bean.getCode().equals(coe_bean.getCar_comp_id())) out.print(cc_bean.getNm());
						} %>
          </td>
          <td width="116" class="title">�ٹ�ó</td>
          <td width="282">&nbsp; <%= c_db.getNameById(coe_bean.getCar_off_id(),"CAR_OFF") %></td>
        </tr>
        <tr> 
          <td class="title">�ּ�</td>
          <td colspan="3">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td class="line"><table width="800" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="87" rowspan="7" class="title"><p>�� �� �� �� </p></td>
          <td width="84" class="title">����</td>
          <td width="222">&nbsp; <%= coe_bean.getEmp_nm() %></td>
          <td width="117" class="title">�ֹε�Ϲ�ȣ</td>
          <td width="284">&nbsp; <%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %> 
          </td>
        </tr>
        <tr> 
          <td class="title">������</td>
          <td>&nbsp; <input type="radio" name="cust_st" value="2"  <% if(coe_bean.getCust_st().equals("2")||coe_bean.getCust_st().equals("")) out.println("checked"); %>>
            ����ҵ�&nbsp; <input type="radio" name="cust_st" value="3"  <% if(coe_bean.getCust_st().equals("3")) out.println("checked"); %>>
            ��Ÿ����ҵ�</td>
          <td class="title">����</td>
          <td>&nbsp; <%= coe_bean.getEmp_pos() %></td>
        </tr>
        <tr> 
          <td class="title">�޴���</td>
          <td>&nbsp; <%= coe_bean.getEmp_m_tel() %></td>
          <td class="title">�̸���</td>
          <td>&nbsp; <%= coe_bean.getEmp_email() %></td>
        </tr>
        <tr> 
          <td class="title">�ּ�</td>
          <td colspan="3">&nbsp; <%= coe_bean.getEmp_post() %> &nbsp; <%= coe_bean.getEmp_addr() %></td>
        </tr>
        <tr> 
          <td class="title">���°�������</td>
          <td colspan="3">&nbsp; <select name="emp_bank" disabled style="width:135">
              <%for(int i=0; i<cd_r.length; i++){
							cd_bean = cd_r[i];%>
              <option value="<%= cd_bean.getNm() %>" <% if(cd_bean.getNm().equals(coe_bean.getEmp_bank())) out.print("selected"); %>><%= cd_bean.getNm() %></option>
              <%}%>
            </select></td>
        </tr>
        <tr> 
          <td class="title">���¹�ȣ</td>
          <td>&nbsp; <%= coe_bean.getEmp_acc_no() %></td>
          <td class="title">�����ָ�</td>
          <td>&nbsp; <%= coe_bean.getEmp_acc_nm() %></td>
        </tr>
        <tr> 
          <td class="title">���Ǽ�</td>
          <td colspan="3">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td class="line"><table width="800" border="0" cellspacing="1" cellpadding="0">
        <%
    for(int i=0; i<coev_r.length; i++){
        coev_bean = coev_r[i];
%>
        <tr> 
          <td width="171" class="title">�޸�</td>
          <td width="562"><textarea name="cont" rows="2" cols="90" readonly><%= coev_bean.getVis_cont() %></textarea></td>
          <td width="63">&nbsp;</td>
        </tr>
        <% } %>
        <tr> 
          <td width="171" class="title">�޸��߰�</td>
          <td width="562"><textarea name="vis_cont" rows="2" cols="90"></textarea></td>
          <td width="63"><a href="javascript:VisReg()" onMouseOver="window.status=''; return true"><img src="/images/add.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
