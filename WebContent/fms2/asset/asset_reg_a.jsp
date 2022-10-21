<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body style="font-size:12">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
    String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
	s_month = AddUtil.addZero(s_month);
	
	String work_st 	= request.getParameter("work_st")==null? "":request.getParameter("work_st");
	String s_gubun = request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");	
	String s_gisu = "";
	String s_flag = "";
	String s_flag4 = "";
	
	int flag = 0;
	int count = 0;
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	
	if(work_st.equals("asset_ma_reg")){//--------------------------------------------------------------------------------------------
	
		s_flag =  as_db.call_sp_insert_assetmaster(s_year, s_month, user_id );
			
		System.out.println("�ڻ���� ���" + s_flag);
		
	//���� �ڻ� ���
	}else if(work_st.equals("asset_move_reg")){//--------------------------------------------------------------------------------------------
		
		s_flag =  as_db.call_sp_insert_assetmove(s_year, s_month, user_id );
	//	s_flag4 = as_db.call_sp_insert_assetmove4(s_year, user_id );	
		System.out.println("�ڻ꺯�� ���" + s_flag + " |" + s_flag4);
			
	//�Ű� �ڻ� ���
	}else if(work_st.equals("asset_move2_reg")){//--------------------------------------------------------------------------------------------
		
		s_flag =  as_db.call_sp_insert_assetmove2(s_year, s_month, user_id );
			
		System.out.println("�ڻ�Ű� ���" + s_flag);
	
	}else if(work_st.equals("asset_ydep_reg")){//--------------------------------------------------------------------------------------------
		
		s_gisu =  as_db.getMaxgisu();
		System.out.println(s_gisu);
		System.out.println("s_year="+s_year);
		
		if ( s_gisu.equals(s_year) ) {		  
		 s_flag =  as_db.call_sp_insert_yassetdep(s_year, user_id );
		 System.out.println("run");      
		} else {
		 s_flag = "1";  //��������� ����� �ƴ� ����� �̿��Ǹ� �ȵ�.
		 System.out.println("err");  
		}
			
		 System.out.println("�ڻ��̿� ���" + s_flag);
		
	}else if(work_st.equals("asset_move_chk")){//--------------------------------------------------------------------------------------------
		
		//[1�ܰ�] :  ������ �ڻ� ��ȸ
		
		Vector vt = as_db.getAssetNoMoveRegList(s_year, s_month);
		int vt_size = vt.size();
		
		out.println("��ϼ�.���԰�ä, ��漼 ��� ��ȸ = "+vt_size+"��<br><br><br>");			
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			flag = 0;
			count = 0;
			
			String car_mng_id 	= String.valueOf(ht.get("CAR_MNG_ID"));
			String car_no 	    = String.valueOf(ht.get("CAR_NO"));
			String assch_date 	= String.valueOf(ht.get("ASSCH_DATE"));
			int capamt 	= Util.parseDigit(String.valueOf(ht.get("CAP_AMT")));	//��ݾ�
		 		
		 	//[2�ܰ�] : fassetma ���̺� ��ϵǾ����� ��ȸ
		 			
		 	String ma_code = "";
		 	ma_code = as_db.getAsset_info(car_mng_id, car_no, "", "code");	
		
			if ( ma_code.equals("")  || ma_code ==  null  ) { 	
				out.println(i+1+")�ڵ���������ȣ="+car_mng_id+", �ڵ�����ȣ="+ car_no + ", �ڻ꺯��ݾ�="+capamt+", �ڻ꺯����="+assch_date+"  Ȯ�ο�!! ");
				out.println("<br>");
		    }
		    
		}	
			
		System.out.println("�����ڻ� üũ" + s_flag);
		
	} else if(work_st.equals("update_assetma")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_update_assetmaster(s_year, s_month, s_gubun, user_id );
			
		System.out.println("������� ����ó��" + s_flag);
	} else if(work_st.equals("insert_assetmove_s")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_insert_assetmove_s(s_year, s_month, user_id );
			
		System.out.println("Ư�Ҽ�ó��" + s_flag);	
	} else if(work_st.equals("insert_assetmove_green")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_insert_assetmove_green(s_year, s_month, user_id );
			
		System.out.println("���ź����� ó��" + s_flag);		
		
	} else if(work_st.equals("update_assetma_deprf")){//--------------------------------------------------------------------------------------------
	

		s_flag =  as_db.call_sp_update_assetmaster_deprf_yn(s_year, s_month, user_id );
			
		System.out.println("�ڻ����(deprf_yn=6 ó��) " + s_flag);			
		
	} 	
		 
 
%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>
<script language='javascript'>
<%	if(work_st.equals("asset_ma_reg") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");
<%	}else if(work_st.equals("asset_move_reg") && !s_flag.equals("0")  ){  %>
	  alert("ó������ �ʾҽ��ϴ�");
<%	}else if(work_st.equals("asset_move2_reg") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");
<%	}else if(work_st.equals("asset_ydep_reg") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");
<%	}else if(work_st.equals("update_assetma") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");	
<%	}else if(work_st.equals("insert_assetmove_s") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");		
<%	}else if(work_st.equals("insert_assetmove_green") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");		
<%	}else if(work_st.equals("update_assetma_deprf") && !s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");														
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
<%	}			%>
</script>
</body>
</html>