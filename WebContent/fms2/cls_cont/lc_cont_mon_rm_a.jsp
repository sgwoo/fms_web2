
<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,  acar.user_mng.*"%>

<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
		
	int flag = 0;	
	
	String from_page 	= "";
	
	String del_chk = "Y";
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag9 = true;
		
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//�����뿩������ �뿩Ƚ�� �ִ밪
	int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd, "1");
		
		
	if(max_fee_tm == 0 && del_chk.equals("Y")){		
		
			flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
				
					//�縮���� ��� ������ �츮��
			if(base.getCar_gu().equals("0") || base.getCar_st().equals("4")){
							
						flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
								//������� ���°� �ʱ�ȭ
						flag9 = a_db.updateCarStatCng(base.getCar_mng_id());
					
			}
		
			System.out.println("����Ʈ ������("+rent_l_cd+")-----------------------");
	}			
	         

	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');
    fm.action='/fms2/cls_cont/lc_cls_rm_d_frame.jsp';		
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
	
	
	
	
	