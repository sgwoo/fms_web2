<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.bill_mng.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");//�α���-������
	
	String adate 	= request.getParameter("adate")==null?"":request.getParameter("adate");//����Ƿ�����
	String r_adate 	= af_db.getValidDt(c_db.addDay(adate, 1));//���Ա����� ����Ƿ��� �������̴�. ������üũ
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int  incom_seq 		= request.getParameter("incom_seq")	==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	int  incom_amt 		= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
	String v_gubun 	= request.getParameter("v_gubun")==null?"N":request.getParameter("v_gubun");

	int flag = 0;
	int count =0;
	int chkdtflag = 0;
	String s_flag = "";
	
	System.out.println("adate=" + adate + ": r_adate = " + r_adate);

	if ( r_adate.length() > 8) { 
		r_adate = r_adate.substring(0,4)+ r_adate.substring(5,7)+ r_adate.substring(8,10);
    }
		
	System.out.println("r_date.len=" + r_adate.length() + ": r_adate = " + r_adate);
		
	if(r_adate.equals(incom_dt) ) {
	
	     
		String target_id = nm_db.getWorkAuthUser("CMS����");  //  "000128";  //cms����		
		
		String insert_id = umd.getSaCode(target_id);
		if(insert_id.equals("")){
			//FMS  ����� ���� ��ȸ
			user_bean 	= umd.getUsersBean(user_id);
			//���� ����� ���� ��ȸ
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
			insert_id = String.valueOf(per.get("SA_CODE"));
		}
		
		System.out.println("target_id id = " + target_id);
		System.out.println("insert id = " + insert_id);
		System.out.println("incom_dt = " + incom_dt);
		System.out.println("incom_seq  = " + incom_seq);
		System.out.println("incom_amt = " + incom_amt);
		System.out.println("v_gubun = " + v_gubun);
				
		// call procedure
		s_flag =  in_db.call_sp_incom_cms_magam(adate, target_id, target_id, incom_dt, incom_seq, incom_amt, v_gubun );
		System.out.println("cms�Ա�ó�� ��� " + s_flag);
		
		// cms ó�� �Ϸ�
		if(!in_db.updateIncomSet( incom_dt, incom_seq, "",  "1" )) flag += 1;
		System.out.println("cms�Ա�ó�� ��� �Ϸ�" + flag);
		
	
	} else { //�Ƿ���+1 �� cms ���� �Ա����� (���̰� �ִٸ� cms ó�� �Ұ� )
	 	chkdtflag = 1;
	} 

%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
</form>
<script language='javascript'>
var fm = document.form1;
<%	if(flag != 0){%>
		alert('�����߻�!');

<%	}else if(count == 1){%>
		alert('�ڵ���ǥ �����߻�!');
		
<%	}else if(!s_flag.equals("0")){%>
		alert('CMS ó�� �����߻�!');		

<%	}else if(chkdtflag == 1){%>
		alert('����Ƿ��� ���� �����߻�!');

<%	}else{%>
		alert('ó���Ǿ����ϴ�');
	    fm.action='/fms2/account/incom_mng_cms_step.jsp';
        fm.target='d_content';		
        fm.submit();

<%	}%>
</script>
</body>
</html>
