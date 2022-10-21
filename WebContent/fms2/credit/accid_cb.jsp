<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*"%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.short_fee_mng.*, acar.user_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//�������Ϸù�ȣ
	String mode = request.getParameter("mode")==null?"8":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	int pay_amt = request.getParameter("pay_amt")==null?0:AddUtil.parseInt(request.getParameter("pay_amt"));//�Աݾ�
			
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
			//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
		
	String bus_id2 = "";
	
	
	//����û����������Ʈ
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
	if(seq_no.equals("")) seq_no = "1";
	
	
	//����û������(����/������)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		
		
	if ( !ma_bean.getBus_id2().equals("")){
	 	bus_id2 = ma_bean.getBus_id2();
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //�������� �����
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	String i_start_dt 	= ma_bean.getIns_use_st();
    	String i_start_h 	= "00";
    	String i_start_s 	= "00";
    	String get_start_dt 	= ma_bean.getIns_use_st();
    	if(get_start_dt.length() == 12){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    		i_start_s	= get_start_dt.substring(10,12);
    	}
	String i_end_dt 	= ma_bean.getIns_use_et();
    	String i_end_h 		= "00";
    	String i_end_s 		= "00";
    	String get_end_dt 	= ma_bean.getIns_use_et();
    	if(get_end_dt.length() == 12){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    		i_end_s		= get_end_dt.substring(10,12);
	}	
	

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���޺���� �հ� ����
	function set_accid_tot_amt(obj){
		var fm = document.form1;
		fm.accid_tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value))); 							
	}
		
	//����/�����Ⱓ ���ڰ��
	function set_ins_use_dt(){
		var fm = document.form1;
		var st = new Date(replaceString("-","/",fm.ins_use_st.value));//������
		var et = new Date(replaceString("-","/",fm.ins_use_et.value));//������
		var days = (et - st) / 1000 / 60 / 60 / 24; //1��=24�ð�*60��*60��*1000milliseconds
		var daysRound = Math.floor(days)+1; //+1:������ ����
		fm.ins_use_day.value = daysRound;
		if(toInt(parseDigit(fm.ins_day_amt.value))==0){
			fm.ins_req_amt.value = parseDecimal(toInt(parseDigit(fm.ins_day_amt.value)) * daysRound * (toInt(fm.ot_fault_per.value)/100));
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}
	}	
	
	//û���ݾ� ����
	function set_ins_amt(){
		var fm = document.form1;		
		fm.ins_req_amt.value = parseDecimal( (toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) * toInt(fm.f_per.value)/100 );
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}else{
			fm.mc_s_amt.value = fm.ins_req_amt.value;
		}
	}
	
	//û���ݾ� ����
	function set_ins_vat_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}
	}	
	
	function set_v_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.mc_s_amt.value)) * 0.1);					
		}
		
	}
			
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}	
	
		
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="accid_u_a.jsp" name="form1">
    <input type="hidden" name="client_id" value="<%=cont.get("CLIENT_ID")%>">
    <input type="hidden" name="site_id" value="">
    <input type="hidden" name="rent_mng_id" value="<%=m_id%>">
    <input type="hidden" name="rent_l_cd" value="<%=l_cd%>">
    <input type="hidden" name="car_mng_id" value="<%=c_id%>">
    <input type="hidden" name="firm_nm" value="<%=cont.get("FIRM_NM")%>">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
    <input type='hidden' name='gubun1' value='<%=gubun1%>'>
    <input type='hidden' name='gubun2' value='<%=gubun2%>'>
    <input type='hidden' name='gubun3' value='<%=gubun3%>'>
    <input type='hidden' name='gubun4' value='<%=gubun4%>'>
    <input type='hidden' name='gubun5' value='<%=gubun5%>'>
    <input type='hidden' name='gubun6' value='<%=gubun6%>'>
    <input type='hidden' name='brch_id' value='<%=brch_id%>'>
    <input type='hidden' name='st_dt' value='<%=st_dt%>'>
    <input type='hidden' name='end_dt' value='<%=end_dt%>'>
    <input type='hidden' name='s_kd' value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' value='<%=t_wd%>'>
    <input type='hidden' name='sort' value='<%=sort%>'>
    <input type='hidden' name='asc' value='<%=asc%>'>
    <input type='hidden' name='s_st' value='<%=s_st%>'>
    <input type='hidden' name='idx' value='<%=idx%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>
    <input type='hidden' name='f_per' value='<%=Math.abs(a_bean.getOur_fault_per()-100)%>'>
    <input type='hidden' name='st' value=''>
    <input type="hidden" name="sender_id" value="<%=user_id%>">
    <input type="hidden" name="target_id" value="000093">
    <input type="hidden" name="coolmsg_sub" value="�������꼭�����û">
    <input type="hidden" name="coolmsg_cont" value="�� �������꼭�����û :: <%=cont.get("FIRM_NM")%>, <%=cont.get("CAR_NO")%>, ����Ͻ�:<%=a_bean.getAccid_dt()%>">
    <input type="hidden" name="seq_no" value="<%=seq_no%>">
    <input type='hidden' name="pubCode" value="">
    <input type='hidden' name="docType" value="">
    <input type='hidden' name="userType" value="">
    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ( ���������ȣ : <%=cont.get("CAR_NO")%> )</span></td>
    </tr>
    <tr>
      <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td class=line colspan="2"><table border="0" cellspacing="1" width=100%>
          <tr>
            <td class=title width=12%>û������</td>
            <td width=22%><select name="ins_req_gu">
                <option value="2" <%if(ma_bean.getIns_req_gu().equals("2"))%>selected<%%>>������</option>
                <option value="1" <%if(ma_bean.getIns_req_gu().equals("1"))%>selected<%%>>������</option>
              </select>
            </td>
            <td class=title width=12%>����</td>
            <td width=21%><select name="ins_req_st">
                <option value="0" <%if(ma_bean.getIns_req_st().equals("0"))%>selected<%%>>��û��</option>
                <option value="1" <%if(ma_bean.getIns_req_st().equals("1"))%>selected<%%>>û��</option>
                <option value="2" <%if(ma_bean.getIns_req_st().equals("2"))%>selected<%%>>�Ϸ�</option>
              </select>
            </td>
            <td class=title width=12%>����������ȣ</td>
            <td width=21%><input type="text" name="ins_car_no" value="<%=ma_bean.getIns_car_no()%>" size="14" class=text maxlength="12">
            </td>
            
          </tr>
			<tr>
				<td class=title>����</td>
				<td><input type="text" name="ins_car_nm" value="<%=ma_bean.getIns_car_nm()%>" class=text size="20" maxlength="30"></td>
				<td class=title>������</td>
            <%	int ot_fault_per = ma_bean.getOt_fault_per();
						if(ot_fault_per==0) ot_fault_per = Math.abs(a_bean.getOur_fault_per()-100);%>
            <td><input type=text name='ot_fault_per' value='<%=ot_fault_per%>' size="5" class=num>
              %</td>
            <td class=title>û������</td>
            <td> 1��
                <input type="text" name="ins_day_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_ins_amt();'>
              ��</td>
			</tr>
          <tr>
            <td class=title> �Ⱓ</td>
            <td colspan="5"><input type="text" name="ins_use_st" value="<%=AddUtil.ChangeDate2(i_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
              <input type="text" name="use_st_h" value="<%=i_start_h%>" size="2" class=text maxlength="12">
              <input type="text" name="use_st_s" value="<%=i_start_s%>" size="2" class=text maxlength="12">
            
              ~
                <input type="text" name="ins_use_et" value="<%=AddUtil.ChangeDate2(i_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="10">
              <input type="text" name="use_et_h" value="<%=i_end_h%>" size="2" class=text maxlength="12">
              <input type="text" name="use_et_s" value="<%=i_end_s%>" size="2" class=text maxlength="12">
              (
              <input type="text" name="ins_use_day" value="<%=ma_bean.getIns_use_day()%>" size="3" class=num onBlur='javscript:set_ins_amt();'>
              ��
              <input type="text" name="ins_use_hour" value="<%=ma_bean.getUse_hour()%>" size="2" class=num onBlur='javscript:set_ins_amt();'>
                      �ð� 	
              )&nbsp; </td>
          </tr>
          <tr>   
            <td class=title>���ް�</td>
            <td><input type="text" name="mc_s_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_v_amt();'>
              �� </td>
              	<td class=title>�ΰ���</td>
            <td><input type="text" name="mc_v_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
              �� 
               <!-- <br>( <input type='checkbox' name='vat_yn' value="Y" <%if(ma_bean.getVat_yn().equals("Y"))%> checked<%%> onClick='javscript:set_ins_vat_amt()'>
                �ΰ�������)
                -->
                </td>
            <td class=title>û���ݾ�</td>
            <td><input type="text" name="ins_req_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
              ��</td>
              
          </tr>
          <tr>
            <td class=title>û������</td>
            <td><input type="text" name="ins_req_dt" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%>" size="12" class=text   onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
            </td>
            <td class=title>û����</td>
            <td colspan="3" ><select name='bus_id2'>
                  <option value="">������</option>
                  <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                  <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                  <%		}
        					}		%>
                </select>
            </td>                        
          </tr>
          <tr>
            <td class=title>��û������</td>
            <td colspan="5"><textarea name="re_reason" cols="60" class="text" rows="4"><%=ma_bean.getRe_reason()%></textarea>
            </td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td class=line colspan="2"><table border="0" cellspacing="1" width=100%>
          <tr>
            <td class=title width=12%>�Աݱݾ�</td>
            <td width=38% colspan="2"><input type="text" name="ins_pay_amt" class=num value="<%=AddUtil.parseDecimal(pay_amt)%>" size="10" >
              �� </td>
            <td class=title width=12%>�Ա�����</td>
            <td width=38% colspan="2"><input type="text" name="ins_pay_dt" class=text value="<%=AddUtil.ChangeDate2(pay_dt)%>" size="15" >
            </td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td class=line colspan="2"><table border="0" cellspacing="1" width=100%>
          <tr>
            <td class=title width=12%>�����</td>
            <td width=38%><input type="text" name="ins_com" value="<%=ma_bean.getIns_com()%>" size="20" class=text>
            </td>
            <td class=title width=12%>������ȣ</td>
            <td width=38%>NO.
                <input name="ins_num" type="text" class=text id="ins_num" value="<%=ma_bean.getIns_num()%>" size="25" maxlength="50" >
            </td>
          </tr>
          <tr>
            <td class=title>��������</td>
            <td><input type="text" name="ins_nm" value="<%=ma_bean.getIns_nm()%>" size="14" class=text maxlength="10" >
            </td>
            <td class=title>����ó��</td>
            <td><input type="text" name="ins_tel" value="<%=ma_bean.getIns_tel()%>" size="20" class=text maxlength="15" >
            </td>
          </tr>
          <tr>
            <td class=title>����ó��</td>
            <td><input type="text" name="ins_tel2" value="<%=ma_bean.getIns_tel2()%>" size="20" class=text maxlength="15" >
            </td>
            <td class=title>�ѽ�</td>
            <td><input type="text" name="ins_fax" value="<%=ma_bean.getIns_fax()%>" size="20" class=text maxlength="15" >
            </td>
          </tr>
          <tr>
            <td class=title>�ּ�</td>
            <td colspan='3'><input type="text" name="ins_addr" value="<%=ma_bean.getIns_addr()%>" size="80" class=text maxlength="200">
            </td>
          </tr>
      </table></td>
    </tr>
    	  
    
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
