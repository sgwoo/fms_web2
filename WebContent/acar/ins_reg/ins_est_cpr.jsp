<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*, java.text.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����

	String air_ds_yn = request.getParameter("air_ds_yn")==null?"":request.getParameter("air_ds_yn");//������ �����
	String air_as_yn = request.getParameter("air_as_yn")==null?"":request.getParameter("air_as_yn");//����������� 
	String com_emp_yn = request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");//����� �Ҽӿ�����
	String age_scp = request.getParameter("age_scp")==null?"":request.getParameter("age_scp");//����� �Ҽӿ�����
	String vins_gcp_kd = request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd");//����� �Ҽӿ�����
	String vins_pcp_kd = request.getParameter("vins_pcp_kd")==null?"":request.getParameter("vins_pcp_kd");//����� �Ҽӿ�����
	String vins_bacdt_kd = request.getParameter("vins_bacdt_kd")==null?"":request.getParameter("vins_bacdt_kd");//����� �Ҽӿ�����
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");//����� �Ҽӿ�����
	String jg_code = request.getParameter("jg_code")==null?"":request.getParameter("jg_code");//����� �Ҽӿ�����
	String ins_start_dt = request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");//����� �Ҽӿ�����
	String ins_exp_dt = request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt");//����� �Ҽӿ�����
	String tot_amt = request.getParameter("tot_amt")==null?"":request.getParameter("tot_amt");//����� �Ҽӿ�����
	tot_amt = tot_amt.replaceAll(",", "");
	ins_start_dt = ins_start_dt.replaceAll("-", "");
	ins_exp_dt = ins_exp_dt.replaceAll("-", "");
	
	/* System.out.println(car_nm);
	System.out.println(air_as_yn);
	System.out.println(air_ds_yn);
	System.out.println(age_scp);
	System.out.println(vins_pcp_kd);
	System.out.println(vins_gcp_kd);
	System.out.println(vins_bacdt_kd);
	System.out.println(com_emp_yn);
	System.out.println(tot_amt);
	System.out.println(jg_code);
	System.out.println(ins_start_dt);
	System.out.println(ins_exp_dt); */
	
	
	SimpleDateFormat format = new SimpleDateFormat("yyyymmdd");
	long reg_ins_term = (format.parse(ins_exp_dt).getTime()-format.parse(ins_start_dt).getTime())/(24 * 60 * 60 * 1000);

	int r_tot_amt = (Integer.parseInt(tot_amt)/(int)reg_ins_term)*365;

	
	
	// �� �÷��� ���� , �����, ����, �빰, ������ 
	// ������ ������ �����ڵ�� ���Ͽ� ���� ������ ��� Ʈ�� ����Ʈ �����ֱ�
	//��ȸ
	InsComDatabase ic_db = InsComDatabase.getInstance();
	Vector accids = new Vector();
	int accid_size =0;
 	accids = ic_db.getEstCprListByCarNm(car_nm, air_as_yn, air_ds_yn, 
			age_scp, vins_pcp_kd, vins_gcp_kd, vins_bacdt_kd, com_emp_yn);
	accid_size = accids.size(); 
	
	if(accid_size ==0){
		accids = ic_db.getEstCprListByJgcode(jg_code, air_as_yn, air_ds_yn, 
				age_scp, vins_pcp_kd, vins_gcp_kd, vins_bacdt_kd, com_emp_yn);
		accid_size = accids.size();
	}
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function reg() {
		var fm = document.form1;	

		var car_mng_id = new Array();
		var ins_st = new Array();
		
		var chklen = fm.chk.length;
		var trueCount = 0;
		
		
		for(i=0; i< chklen; i++){
			if(fm.chk[i].checked == true){
				trueCount++;
			 }
		}
		
		if(!chklen){
			var chval = fm.chk.value;
			if(chval)trueCount++;
		}
		
		if(trueCount>0){
			fm.action = "ins_com_filereq_add.jsp";		
		 	fm.submit(); 
		}else{
			alert("�ش� ����Ʈ�� üũ���ּ���");
			return;
		}
	}
	
	function gubun3Change(val){
		var fm = document.form1;
	  	if(val == '�Ⱓ'){
	  		var date = new Date();
	  		fm.st_dt.value =getFormatDate(date)-3;
	  		fm.end_dt.value = getFormatDate(date);
		}else{
			fm.st_dt.value ="";
	  		fm.end_dt.value = "";
		} 
	}
	
	function getFormatDate(date){
		var year = date.getFullYear();                 
		return  year;
	}
	
	
	
</script>
</head>

<body>
<form name='form1' method='post' action='/fms2/ins_com/search.jsp'>

<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='ins_st' value=''>
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>������ȸ����Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
      <tr>
        <td>�ֱٵ�ϼ�</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="2%"></td>
                    <td class=title width="5%">����</td>
                    <td class=title width="4%">����</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="6%">������ȣ</td>
                 <!--    <td class=title width="6%">������</td> -->
                  <!--   <td class=title width="7%">���ι��</td>
                    <td class=title width="7%">���ι��</td>
                    <td class=title width="7%">�빰���</td>
                    <td class=title width="7%">�ڱ��ü���</td>			
                    <td class=title width="7%">���������</td>			
                    <td class=title width="7%">�д����������</td>
                    <td class=title width="7%">�ڱ����</td>
                    <td class=title width="7%">Ư��</td> -->
                    <td class=title width="7%">�Ѻ����</td>
                    <td style="color:red;" class=title width="7%">������ ��</td>
                    <td style="color:red;" class=title width="7%">��1��ġ �����</td>
                    <td style="color:red;" class=title width="7%">�غ���� ����</td>
                </tr>
              <%for (int i = 0 ; i < accid_size ; i++){
    			Hashtable accid = (Hashtable)accids.elementAt(i);
    			int compEst =r_tot_amt-AddUtil.parseInt(String.valueOf(accid.get("TOT_AMT")));
    			long ins_term = (format.parse(String.valueOf(accid.get("INS_EXP_DT"))).getTime()-format.parse(String.valueOf(accid.get("INS_START_DT"))).getTime());
    			%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=Util.subData(String.valueOf(accid.get("INS_COM_NM")), 3)%></td>
                    <td> 
                      <%if(accid.get("INS_STS").equals("1")&&accid.get("USE_YN").equals("Y")){%>
                    	  ���� 
                      <%}else{%>
                     	  ���� 
                      <%}%>
                    </td>
                    <td><%=accid.get("CAR_NAME")%></td>
                    <td><%=accid.get("CAR_NO")%></td>
                  <%--   <td><%=accid.get("INS_START_DT")%></td> --%>
                   <%--  <td><%=AddUtil.parseDecimal(accid.get("RINS_PCP_AMT"))%></td>
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_PCP_AMT"))%></td>
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_GCP_AMT"))%></td>			
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_BACDT_AMT"))%></td>			
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_CANOISR_AMT"))%></td>			
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_SHARE_EXTRA_AMT"))%></td>			
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_CACDT_CM_AMT"))%></td>			
                    <td><%=AddUtil.parseDecimal(accid.get("VINS_SPE_AMT"))%></td>			 --%>
                    <td><%=AddUtil.parseDecimal(accid.get("TOT_AMT"))%></td>	
                    <td><%=reg_ins_term%>��</td>	
                    <td><%=AddUtil.parseDecimal(r_tot_amt)%></td>	
                    
                    <%if(compEst>0){%>
	                    <td style="color:blue;font-weight:bold;">+<%=AddUtil.parseDecimal(compEst)%></td>			
                    <%}else{%>		
	                    <td style="color:red;font-weight:bold;"><%=AddUtil.parseDecimal(compEst)%></td>			
                    <%}%>		
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
